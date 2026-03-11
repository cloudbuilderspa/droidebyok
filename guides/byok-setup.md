# BYOK Setup (English / Español)

## English

### Config Files
Factory Droid supports two config files, but **prefer `settings.json`**:

| File | Purpose | Field style |
|---|---|---|
| `~/.factory/settings.json` | Active custom models | camelCase (`baseUrl`, `apiKey`) |
| `~/.factory/config.json` | Legacy / reserved | snake_case (`base_url`, `api_key`) |

**Rule:** Do not define the same model in both files.

### Provider & Endpoint Mapping
Use the correct provider for each endpoint:

| Provider | Base URL | Use case |
|---|---|---|
| `generic-chat-completion-api` | `https://api.z.ai/api/coding/paas/v4` | Z.AI GLM models |
| `anthropic` | `http://127.0.0.1:8045` | Antigravity Manager (Anthropic endpoint) |
| `openai` | `http://127.0.0.1:8045/v1` | Antigravity Manager (OpenAI-compatible endpoint) |
| `openai` | `http://127.0.0.1:8317/v1` | VibeProxy OpenAI-compatible models |
| `anthropic` | `http://127.0.0.1:8317` | VibeProxy Anthropic-compatible models |

### Streaming Required
Always set `"stream": true` for custom models. Some providers require streaming for long operations.

### Example (settings.json)
```json
{
  "customModels": [
    {
      "model": "glm-5",
      "displayName": "GLM-5",
      "baseUrl": "https://api.z.ai/api/coding/paas/v4",
      "apiKey": "<ZAI_API_KEY>",
      "provider": "generic-chat-completion-api",
      "maxOutputTokens": 131072,
      "stream": true
    }
  ]
}
```

### Common Errors
| Error | Cause | Fix |
|---|---|---|
| `Streaming is required` | `stream` missing or wrong provider | Set `stream: true` and fix provider/endpoint |
| `400` | Provider/endpoint mismatch | Verify provider mapping table |
| Model not visible | Defined in both files | Keep only in `settings.json` |

---

## Español

### Archivos de Configuración
Factory Droid soporta dos archivos, pero **se recomienda `settings.json`**:

| Archivo | Uso | Formato |
|---|---|---|
| `~/.factory/settings.json` | Modelos activos | camelCase (`baseUrl`, `apiKey`) |
| `~/.factory/config.json` | Legacy / reservado | snake_case (`base_url`, `api_key`) |

**Regla:** No definas el mismo modelo en ambos archivos.

### Provider y Endpoint
Usa el provider correcto según el endpoint:

| Provider | Base URL | Uso |
|---|---|---|
| `generic-chat-completion-api` | `https://api.z.ai/api/coding/paas/v4` | Modelos GLM de Z.AI |
| `anthropic` | `http://127.0.0.1:8045` | Antigravity Manager (endpoint Anthropic) |
| `openai` | `http://127.0.0.1:8045/v1` | Antigravity Manager (endpoint OpenAI) |
| `openai` | `http://127.0.0.1:8317/v1` | VibeProxy OpenAI-compatible |
| `anthropic` | `http://127.0.0.1:8317` | VibeProxy Anthropic-compatible |

### Streaming Requerido
Siempre usa `"stream": true` en modelos custom.

### Ejemplo (settings.json)
```json
{
  "customModels": [
    {
      "model": "glm-5",
      "displayName": "GLM-5",
      "baseUrl": "https://api.z.ai/api/coding/paas/v4",
      "apiKey": "<ZAI_API_KEY>",
      "provider": "generic-chat-completion-api",
      "maxOutputTokens": 131072,
      "stream": true
    }
  ]
}
```
