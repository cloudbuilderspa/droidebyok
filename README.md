# Public BYOK / VibeProxy / Antigravity Manager Guide

## English

This repo documents a **sanitized** setup for running BYOK models with Factory Droid using VibeProxy and Antigravity Manager. All secrets are replaced with placeholders.

### Quick Start
1. Read **BYOK basics**: `guides/byok-setup.md`
2. Install & configure **VibeProxy**: `guides/vibeproxy-setup.md`
3. Configure **Antigravity Manager**: `guides/antigravity-manager.md`
4. Run the interactive setup script:
   ```bash
   bash scripts/setup-byok.sh
   ```

### What the Script Does
- Prompts you for API keys (manual input).
- Prompts you to select providers and models.
- Supports **VibeProxy, Antigravity, Z.AI GLM, MiniMax, Kimi**.
- Backs up existing `~/.factory/settings.json` and `~/.factory/config.json`.
- Writes **both** config files with selected models.

### Safety Notes
- Never commit real API keys. Use placeholders like `<API_KEY>`.
- Use `~` or `<HOME>` in paths for public docs.
- Avoid sharing local config files that contain secrets.

### Repo Structure
```
public-byok-guide/
  README.md
  guides/
    byok-setup.md
    vibeproxy-setup.md
    antigravity-manager.md
  examples/
    settings.json.example
    config.json.example
  scripts/
    setup-byok.sh
```

---

## Español

Este repo documenta una configuración **sanitizada** para usar modelos BYOK con Factory Droid mediante VibeProxy y Antigravity Manager. Todos los secretos se reemplazan con placeholders.

### Inicio Rápido
1. Lee **BYOK básico**: `guides/byok-setup.md`
2. Instala y configura **VibeProxy**: `guides/vibeproxy-setup.md`
3. Configura **Antigravity Manager**: `guides/antigravity-manager.md`
4. Ejecuta el script interactivo:
   ```bash
   bash scripts/setup-byok.sh
   ```

### Qué Hace el Script
- Pide tus API keys manualmente.
- Te deja elegir providers y modelos.
- Soporta **VibeProxy, Antigravity, Z.AI GLM, MiniMax, Kimi**.
- Respalda `~/.factory/settings.json` y `~/.factory/config.json`.
- Escribe **ambos** archivos con los modelos seleccionados.

### Notas de Seguridad
- Nunca publiques API keys reales. Usa placeholders como `<API_KEY>`.
- En rutas usa `~` o `<HOME>`.
- Evita subir archivos locales que contengan secretos.
