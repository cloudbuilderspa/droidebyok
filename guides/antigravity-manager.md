# Antigravity Manager (English / Español)

## English

### Endpoints
- Anthropic-compatible: `http://127.0.0.1:8045`
- OpenAI-compatible: `http://127.0.0.1:8045/v1`

### Provider Mapping
| Model type | Provider | Base URL |
|---|---|---|
| Claude (Anthropic) | `anthropic` | `http://127.0.0.1:8045` |
| Gemini / GPT (OpenAI-compatible) | `openai` | `http://127.0.0.1:8045/v1` |

### Example (settings.json)
```json
{
  "customModels": [
    {
      "model": "claude-opus-4-6-thinking",
      "displayName": "AG: Claude Opus 4.6 Thinking",
      "baseUrl": "http://127.0.0.1:8045",
      "apiKey": "<AG_API_KEY>",
      "provider": "anthropic",
      "maxOutputTokens": 4096,
      "stream": true
    },
    {
      "model": "gemini-3.1-pro-high",
      "displayName": "AG: Gemini 3.1 Pro High",
      "baseUrl": "http://127.0.0.1:8045/v1",
      "apiKey": "<AG_API_KEY>",
      "provider": "openai",
      "maxOutputTokens": 4096,
      "stream": true
    }
  ]
}
```

### Troubleshooting
| Symptom | Cause | Fix |
|---|---|---|
| `400` or `502` | Provider/endpoint mismatch | Use the mapping table above |
| Requests go to old port | Cached URL in session | Restart Droid (`/exit`) |

---

## Español

### Endpoints
- Anthropic-compatible: `http://127.0.0.1:8045`
- OpenAI-compatible: `http://127.0.0.1:8045/v1`

### Mapeo de Provider
| Tipo de modelo | Provider | Base URL |
|---|---|---|
| Claude (Anthropic) | `anthropic` | `http://127.0.0.1:8045` |
| Gemini / GPT (OpenAI-compatible) | `openai` | `http://127.0.0.1:8045/v1` |

### Ejemplo (settings.json)
```json
{
  "customModels": [
    {
      "model": "claude-opus-4-6-thinking",
      "displayName": "AG: Claude Opus 4.6 Thinking",
      "baseUrl": "http://127.0.0.1:8045",
      "apiKey": "<AG_API_KEY>",
      "provider": "anthropic",
      "maxOutputTokens": 4096,
      "stream": true
    },
    {
      "model": "gemini-3.1-pro-high",
      "displayName": "AG: Gemini 3.1 Pro High",
      "baseUrl": "http://127.0.0.1:8045/v1",
      "apiKey": "<AG_API_KEY>",
      "provider": "openai",
      "maxOutputTokens": 4096,
      "stream": true
    }
  ]
}
```
