## Infrastructure Management Automations

> **📖 Related Documentation:** [Setup Guide](../setup/0%20-%20Setup%20Guide.md) | [Network Summary](../network/Network%20Summary.md)


### 1. Service Health Monitoring & Auto-Recovery
```javascript
// Workflow: Monitor services and auto-restart failed containers
{
  "name": "Service Health Monitor",
  "nodes": [
    {
      "name": "Every 5 Minutes",
      "type": "n8n-nodes-base.cron",
      "parameters": {
        "rule": {"interval": [{"field": "minute", "value": 5}]}
      }
    },
    {
      "name": "Check Docker Services",
      "type": "n8n-nodes-base.executeCommand",
      "parameters": {
        "command": "docker ps --filter 'status=exited' --format '{{.Names}}'"
      }
    },
    {
      "name": "If Services Down",
      "type": "n8n-nodes-base.if",
      "parameters": {
        "conditions": {
          "string": [{"value1": "={{$json.stdout}}", "operation": "isNotEmpty"}]
        }
      }
    },
    {
      "name": "Restart Failed Services",
      "type": "n8n-nodes-base.executeCommand",
      "parameters": {
        "command": "docker restart {{$json.stdout}}"
      }
    },
    {
      "name": "Send Alert",
      "type": "n8n-nodes-base.discord",
      "parameters": {
        "text": "🔄 Auto-restarted failed service: {{$json.stdout}}"
      }
    }
  ]
}
```

### 2. Backup Verification & Reporting
```javascript
// Workflow: Verify backups completed successfully
{
  "name": "Daily Backup Report",
  "nodes": [
    {
      "name": "Daily at 8 AM",
      "type": "n8n-nodes-base.cron",
      "parameters": {
        "rule": {"hour": 8, "minute": 0}
      }
    },
    {
      "name": "Check Backup Logs",
      "type": "n8n-nodes-base.executeCommand",
      "parameters": {
        "command": "find /var/log -name '*backup*' -mtime -1 -exec grep -l 'completed successfully' {} \\;"
      }
    },
    {
      "name": "Get Backup Sizes",
      "type": "n8n-nodes-base.executeCommand",
      "parameters": {
        "command": "du -sh /mnt/backup/* | tail -7"
      }
    },
    {
      "name": "Create Report",
      "type": "n8n-nodes-base.function",
      "parameters": {
        "functionCode": `
          const backups = $input.all();
          const report = {
            date: new Date().toLocaleDateString(),
            successful: backups[0].json.stdout.split('\\n').length - 1,
            sizes: backups[1].json.stdout
          };
          return [{json: report}];
        `
      }
    },
    {
      "name": "Email Report",
      "type": "n8n-nodes-base.emailSend",
      "parameters": {
        "subject": "Daily Backup Report - {{$json.date}}",
        "text": "Successful backups: {{$json.successful}}\\n\\nSizes:\\n{{$json.sizes}}"
      }
    }
  ]
}
```

### 3. Resource Usage Alerts
```javascript
// Workflow: Monitor system resources and alert on high usage
{
  "name": "Resource Monitor",
  "nodes": [
    {
      "name": "Every 10 Minutes",
      "type": "n8n-nodes-base.cron"
    },
    {
      "name": "Check CPU Usage",
      "type": "n8n-nodes-base.executeCommand",
      "parameters": {
        "command": "top -bn1 | grep 'Cpu(s)' | awk '{print $2}' | cut -d'%' -f1"
      }
    },
    {
      "name": "Check Memory Usage",
      "type": "n8n-nodes-base.executeCommand",
      "parameters": {
        "command": "free | grep Mem | awk '{printf \"%.1f\", $3/$2 * 100.0}'"
      }
    },
    {
      "name": "Check Disk Usage",
      "type": "n8n-nodes-base.executeCommand",
      "parameters": {
        "command": "df -h / | awk 'NR==2{print $5}' | cut -d'%' -f1"
      }
    },
    {
      "name": "Evaluate Thresholds",
      "type": "n8n-nodes-base.function",
      "parameters": {
        "functionCode": `
          const cpu = parseFloat($input.all()[0].json.stdout);
          const memory = parseFloat($input.all()[1].json.stdout);
          const disk = parseInt($input.all()[2].json.stdout);
          
          const alerts = [];
          if (cpu > 80) alerts.push(\`CPU: \${cpu}%\`);
          if (memory > 85) alerts.push(\`Memory: \${memory}%\`);
          if (disk > 90) alerts.push(\`Disk: \${disk}%\`);
          
          return alerts.length > 0 ? [{json: {alerts, severity: 'high'}}] : [];
        `
      }
    },
    {
      "name": "Send Alert",
      "type": "n8n-nodes-base.slack",
      "parameters": {
        "text": "🚨 High resource usage detected:\\n{{$json.alerts.join('\\n')}}"
      }
    }
  ]
}
```

## Media Management Automations

### 4. Smart Media Request Processing
```javascript
// Workflow: Process Overseerr requests with intelligence
{
  "name": "Smart Media Requests",
  "nodes": [
    {
      "name": "Overseerr Webhook",
      "type": "n8n-nodes-base.webhook",
      "parameters": {"path": "overseerr-request"}
    },
    {
      "name": "Parse Request",
      "type": "n8n-nodes-base.function",
      "parameters": {
        "functionCode": `
          const request = $input.first().json;
          return [{
            json: {
              type: request.media_type,
              title: request.subject,
              tmdbId: request.media.tmdbId,
              user: request.request.requestedBy.displayName,
              priority: request.request.requestedBy.requestCount < 5 ? 'high' : 'normal'
            }
          }];
        `
      }
    },
    {
      "name": "Check Available Storage",
      "type": "n8n-nodes-base.executeCommand",
      "parameters": {
        "command": "df -h /mnt/media | awk 'NR==2{print $4}' | sed 's/G//'"
      }
    },
    {
      "name": "If Sufficient Space",
      "type": "n8n-nodes-base.if",
      "parameters": {
        "conditions": {
          "number": [{"value1": "={{parseInt($json.stdout)}}", "operation": "larger", "value2": 50}]
        }
      }
    },
    {
      "name": "Add to Sonarr/Radarr",
      "type": "n8n-nodes-base.httpRequest",
      "parameters": {
        "url": "={{$json.type === 'tv' ? 'http://sonarr.lab.local:8989' : 'http://radarr.lab.local:7878'}}/api/v3/{{$json.type === 'tv' ? 'series' : 'movie'}}",
        "method": "POST",
        "body": {
          "tmdbId": "={{$json.tmdbId}}",
          "monitored": true,
          "qualityProfileId": "={{$json.priority === 'high' ? 4 : 1}}",
          "addOptions": {"searchForMovie": true}
        }
      }
    },
    {
      "name": "Update Home Assistant",
      "type": "n8n-nodes-base.homeAssistant",
      "parameters": {
        "service": "notify.mobile_app",
        "data": {
          "message": "📺 {{$json.title}} added to download queue",
          "title": "Media Request Processed"
        }
      }
    }
  ]
}
```

### 5. Failed Download Management
```javascript
// Workflow: Handle failed downloads and retry logic
{
  "name": "Failed Download Handler",
  "nodes": [
    {
      "name": "Daily Check",
      "type": "n8n-nodes-base.cron",
      "parameters": {"rule": {"hour": 10, "minute": 0}}
    },
    {
      "name": "Get Failed Downloads",
      "type": "n8n-nodes-base.httpRequest",
      "parameters": {
        "url": "http://sonarr.lab.local:8989/api/v3/queue",
        "headers": {"X-Api-Key": "{{$env.SONARR_API_KEY}}"}
      }
    },
    {
      "name": "Filter Failed Items",
      "type": "n8n-nodes-base.function",
      "parameters": {
        "functionCode": `
          const queue = $input.first().json.records;
          const failed = queue.filter(item => 
            item.status === 'failed' || 
            item.status === 'warning' ||
            (item.status === 'downloading' && 
             new Date() - new Date(item.added) > 24 * 60 * 60 * 1000)
          );
          return failed.map(item => ({json: item}));
        `
      }
    },
    {
      "name": "Remove Failed",
      "type": "n8n-nodes-base.httpRequest",
      "parameters": {
        "url": "http://sonarr.lab.local:8989/api/v3/queue/{{$json.id}}",
        "method": "DELETE",
        "headers": {"X-Api-Key": "{{$env.SONARR_API_KEY}}"}
      }
    },
    {
      "name": "Search Alternative",
      "type": "n8n-nodes-base.httpRequest",
      "parameters": {
        "url": "http://sonarr.lab.local:8989/api/v3/command",
        "method": "POST",
        "body": {
          "name": "EpisodeSearch",
          "episodeIds": ["{{$json.episodeId}}"]
        }
      }
    },
    {
      "name": "Log to Database",
      "type": "n8n-nodes-base.postgres",
      "parameters": {
        "query": "INSERT INTO failed_downloads (title, reason, retry_count, date) VALUES ($1, $2, $3, NOW())",
        "values": ["{{$json.title}}", "{{$json.statusMessages[0].title}}", 1]
      }
    }
  ]
}
```

## Home Automation Integrations

### 6. Smart Lighting Based on Media Playback
```javascript
// Workflow: Dim lights when movie starts, restore when paused/stopped
{
  "name": "Movie Night Lighting",
  "nodes": [
    {
      "name": "Plex Webhook",
      "type": "n8n-nodes-base.webhook",
      "parameters": {"path": "plex-events"}
    },
    {
      "name": "Parse Plex Event",
      "type": "n8n-nodes-base.function",
      "parameters": {
        "functionCode": `
          const payload = JSON.parse($input.first().json.payload);
          const event = payload.event;
          const metadata = payload.Metadata;
          
          if (!metadata || metadata.type !== 'movie') return [];
          
          return [{
            json: {
              event: event,
              title: metadata.title,
              player: payload.Player.title,
              user: payload.Account.title
            }
          }];
        `
      }
    },
    {
      "name": "Check Event Type",
      "type": "n8n-nodes-base.switch",
      "parameters": {
        "values": [
          {"conditions": [{"leftValue": "={{$json.event}}", "operation": "equal", "rightValue": "media.play"}]},
          {"conditions": [{"leftValue": "={{$json.event}}", "operation": "equal", "rightValue": "media.pause"}]},
          {"conditions": [{"leftValue": "={{$json.event}}", "operation": "equal", "rightValue": "media.stop"}]}
        ]
      }
    },
    {
      "name": "Dim Lights",
      "type": "n8n-nodes-base.homeAssistant",
      "parameters": {
        "service": "light.turn_on",
        "domain": "light",
        "data": {
          "entity_id": "light.living_room_group",
          "brightness": 30,
          "transition": 5
        }
      }
    },
    {
      "name": "Restore Lights",
      "type": "n8n-nodes-base.homeAssistant",
      "parameters": {
        "service": "light.turn_on",
        "domain": "light",
        "data": {
          "entity_id": "light.living_room_group",
          "brightness": 255,
          "transition": 2
        }
      }
    }
  ]
}
```

### 7. Energy Usage Monitoring & Alerts
```javascript
// Workflow: Monitor power usage and send efficiency reports
{
  "name": "Energy Monitor",
  "nodes": [
    {
      "name": "Hourly Check",
      "type": "n8n-nodes-base.cron",
      "parameters": {"rule": {"minute": 0}}
    },
    {
      "name": "Get Power Usage",
      "type": "n8n-nodes-base.homeAssistant",
      "parameters": {
        "service": "sensor.get_state",
        "entity_id": "sensor.home_power_consumption"
      }
    },
    {
      "name": "Get UPS Status",
      "type": "n8n-nodes-base.executeCommand",
      "parameters": {
        "command": "apcaccess status | grep -E 'LOADPCT|BCHARGE|TIMELEFT'"
      }
    },
    {
      "name": "Calculate Efficiency",
      "type": "n8n-nodes-base.function",
      "parameters": {
        "functionCode": `
          const power = parseFloat($input.all()[0].json.state);
          const hour = new Date().getHours();
          
          // Define baseline usage patterns
          const baseline = {
            night: 800,    // 11PM - 6AM
            morning: 1200, // 6AM - 10AM
            day: 1000,     // 10AM - 6PM
            evening: 1400  // 6PM - 11PM
          };
          
          let period, expected;
          if (hour >= 23 || hour < 6) { period = 'night'; expected = baseline.night; }
          else if (hour < 10) { period = 'morning'; expected = baseline.morning; }
          else if (hour < 18) { period = 'day'; expected = baseline.day; }
          else { period = 'evening'; expected = baseline.evening; }
          
          const efficiency = ((expected - power) / expected * 100).toFixed(1);
          
          return [{
            json: {
              current_
---
*Note: This is a sanitized example. Replace placeholder values with your actual configuration.*
