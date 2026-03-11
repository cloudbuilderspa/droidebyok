# VibeProxy Setup (English / Español)

## English

### Install
1. Download **VibeProxy** from the official GitHub releases.
2. Move `VibeProxy.app` to `/Applications`.
3. Open the app and authenticate (Claude/ChatGPT/Gemini as supported).

### Endpoints
- Anthropic-compatible: `http://127.0.0.1:8317`
- OpenAI-compatible: `http://127.0.0.1:8317/v1`

### Strict Model Rules (gpt-*)
If the model name starts with `gpt-`, Droid enforces the `openai` provider. Ensure:
1. `"model"` matches the exact VibeProxy model ID.
2. `"provider": "openai"`.
3. `"baseUrl": "http://127.0.0.1:8317/v1"`.
4. Restart Droid after config changes (cache may keep old URLs).

### Recommended Setup
Use the interactive script and select only the models you want:
```bash
bash scripts/setup-byok.sh
```

### Example (config.json)
```json
{
  "custom_models": [
    {
      "model": "gpt-5.2-codex",
      "model_display_name": "VP: GPT-5.2 Codex",
      "base_url": "http://127.0.0.1:8317/v1",
      "api_key": "<VIBEPROXY_OAUTH_TOKEN>",
      "provider": "openai",
      "max_tokens": 4096,
      "stream": true
    }
  ]
}
```

---

## Español

### Instalación
1. Descarga **VibeProxy** desde GitHub releases oficial.
2. Mueve `VibeProxy.app` a `/Applications`.
3. Abre la app y autentica las cuentas soportadas.

### Endpoints
- Anthropic-compatible: `http://127.0.0.1:8317`
- OpenAI-compatible: `http://127.0.0.1:8317/v1`

### Reglas Estrictas (gpt-*)
Si el modelo inicia con `gpt-`, Droid exige `provider: openai`. Asegura:
1. `"model"` coincide con el ID exacto del modelo en VibeProxy.
2. `"provider": "openai"`.
3. `"baseUrl": "http://127.0.0.1:8317/v1"`.
4. Reinicia Droid después de cambios (cache de URLs).

### Setup Recomendado
Usa el script interactivo y selecciona solo los modelos que quieras:
```bash
bash scripts/setup-byok.sh
```

### Ejemplo (config.json)
```json
{
  "custom_models": [
    {
      "model": "gpt-5.2-codex",
      "model_display_name": "VP: GPT-5.2 Codex",
      "base_url": "http://127.0.0.1:8317/v1",
      "api_key": "<VIBEPROXY_OAUTH_TOKEN>",
      "provider": "openai",
      "max_tokens": 4096,
      "stream": true
    }
  ]
}
```
