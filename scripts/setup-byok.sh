#!/usr/bin/env bash
set -euo pipefail

FACTORY_DIR="${HOME}/.factory"
SETTINGS_FILE="${FACTORY_DIR}/settings.json"
CONFIG_FILE="${FACTORY_DIR}/config.json"

mkdir -p "${FACTORY_DIR}"

echo "BYOK setup for Factory Droid"

echo "Select proxy to configure:"
echo "  1) VibeProxy (localhost:8317)"
echo "  2) Antigravity Manager (localhost:8045)"
read -r -p "Choice [1/2]: " PROXY_CHOICE

if [[ "${PROXY_CHOICE}" != "1" && "${PROXY_CHOICE}" != "2" ]]; then
  echo "Invalid choice. Exiting."
  exit 1
fi

read -r -s -p "AG API key (press enter if not needed): " AG_KEY
printf "\n"
read -r -s -p "VibeProxy token (press enter if not needed): " VP_KEY
printf "\n"
read -r -s -p "Z.AI API key (optional, press enter to skip): " ZAI_KEY
printf "\n"

read -r -p "Proceed and overwrite settings/config files? (y/N): " CONFIRM
if [[ ! "${CONFIRM}" =~ ^[Yy]$ ]]; then
  echo "Cancelled."
  exit 0
fi

backup_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    local ts
    ts=$(date "+%Y%m%d-%H%M%S")
    cp "$file" "${file}.bak-${ts}"
  fi
}

backup_file "${SETTINGS_FILE}"
backup_file "${CONFIG_FILE}"

settings_entries=()
config_entries=()

add_setting_model() {
  local model="$1" display="$2" base="$3" key="$4" provider="$5" max="$6"
  settings_entries+=("    {\n      \"model\": \"${model}\",\n      \"displayName\": \"${display}\",\n      \"baseUrl\": \"${base}\",\n      \"apiKey\": \"${key}\",\n      \"provider\": \"${provider}\",\n      \"maxOutputTokens\": ${max},\n      \"stream\": true\n    }")
}

add_config_model() {
  local model="$1" display="$2" base="$3" key="$4" provider="$5" max="$6"
  config_entries+=("    {\n      \"model\": \"${model}\",\n      \"model_display_name\": \"${display}\",\n      \"base_url\": \"${base}\",\n      \"api_key\": \"${key}\",\n      \"provider\": \"${provider}\",\n      \"max_tokens\": ${max},\n      \"stream\": true\n    }")
}

join_by() {
  local IFS="$1"
  shift
  printf "%s" "$*"
}

if [[ -n "${ZAI_KEY}" ]]; then
  add_setting_model "glm-5" "GLM-5" "https://api.z.ai/api/coding/paas/v4" "${ZAI_KEY}" "generic-chat-completion-api" 131072
fi

if [[ "${PROXY_CHOICE}" == "1" ]]; then
  if [[ -z "${VP_KEY}" ]]; then
    echo "VibeProxy token is required for this choice."
    exit 1
  fi
  add_setting_model "claude-opus-4-6-thinking" "VP: Claude Opus 4.6 Thinking" "http://127.0.0.1:8317" "${VP_KEY}" "anthropic" 4096
  add_setting_model "claude-sonnet-4-6" "VP: Claude Sonnet 4.6" "http://127.0.0.1:8317" "${VP_KEY}" "anthropic" 4096
  add_setting_model "gemini-3-pro-high" "VP: Gemini 3 Pro High" "http://127.0.0.1:8317/v1" "${VP_KEY}" "openai" 4096
  add_setting_model "gemini-3-pro-low" "VP: Gemini 3 Pro Low" "http://127.0.0.1:8317/v1" "${VP_KEY}" "openai" 4096
  add_setting_model "gemini-3.1-pro-high" "VP: Gemini 3.1 Pro High" "http://127.0.0.1:8317/v1" "${VP_KEY}" "openai" 4096
  add_setting_model "gemini-3.1-pro-low" "VP: Gemini 3.1 Pro Low" "http://127.0.0.1:8317/v1" "${VP_KEY}" "openai" 4096
  add_setting_model "gemini-3-flash" "VP: Gemini 3 Flash" "http://127.0.0.1:8317/v1" "${VP_KEY}" "openai" 4096
  add_setting_model "gemini-2.5-flash" "VP: Gemini 2.5 Flash" "http://127.0.0.1:8317/v1" "${VP_KEY}" "openai" 4096
  add_setting_model "gemini-2.5-flash-lite" "VP: Gemini 2.5 Flash Lite" "http://127.0.0.1:8317/v1" "${VP_KEY}" "openai" 4096
  add_setting_model "gpt-oss-120b-medium" "VP: GPT OSS 120B Medium" "http://127.0.0.1:8317/v1" "${VP_KEY}" "openai" 4096

  add_config_model "claude-opus-4-6-thinking" "VP: Claude Opus 4.6 Thinking" "http://127.0.0.1:8317" "${VP_KEY}" "anthropic" 4096
  add_config_model "claude-sonnet-4-6" "VP: Claude Sonnet 4.6" "http://127.0.0.1:8317" "${VP_KEY}" "anthropic" 4096
  add_config_model "gemini-3-pro-high" "VP: Gemini 3 Pro High" "http://127.0.0.1:8317/v1" "${VP_KEY}" "openai" 4096
  add_config_model "gemini-3-pro-low" "VP: Gemini 3 Pro Low" "http://127.0.0.1:8317/v1" "${VP_KEY}" "openai" 4096
  add_config_model "gemini-3.1-pro-high" "VP: Gemini 3.1 Pro High" "http://127.0.0.1:8317/v1" "${VP_KEY}" "openai" 4096
  add_config_model "gemini-3.1-pro-low" "VP: Gemini 3.1 Pro Low" "http://127.0.0.1:8317/v1" "${VP_KEY}" "openai" 4096
  add_config_model "gemini-3-flash" "VP: Gemini 3 Flash" "http://127.0.0.1:8317/v1" "${VP_KEY}" "openai" 4096
  add_config_model "gemini-2.5-flash" "VP: Gemini 2.5 Flash" "http://127.0.0.1:8317/v1" "${VP_KEY}" "openai" 4096
  add_config_model "gemini-2.5-flash-lite" "VP: Gemini 2.5 Flash Lite" "http://127.0.0.1:8317/v1" "${VP_KEY}" "openai" 4096
  add_config_model "gpt-oss-120b-medium" "VP: GPT OSS 120B Medium" "http://127.0.0.1:8317/v1" "${VP_KEY}" "openai" 4096
else
  if [[ -z "${AG_KEY}" ]]; then
    echo "AG API key is required for this choice."
    exit 1
  fi
  add_setting_model "claude-opus-4-6-thinking" "AG: Claude Opus 4.6 Thinking" "http://127.0.0.1:8045" "${AG_KEY}" "anthropic" 4096
  add_setting_model "claude-sonnet-4-6" "AG: Claude Sonnet 4.6" "http://127.0.0.1:8045" "${AG_KEY}" "anthropic" 4096
  add_setting_model "gemini-3-pro-high" "AG: Gemini 3 Pro High" "http://127.0.0.1:8045/v1" "${AG_KEY}" "openai" 4096
  add_setting_model "gemini-3-pro-low" "AG: Gemini 3 Pro Low" "http://127.0.0.1:8045/v1" "${AG_KEY}" "openai" 4096
  add_setting_model "gemini-3.1-pro-high" "AG: Gemini 3.1 Pro High" "http://127.0.0.1:8045/v1" "${AG_KEY}" "openai" 4096
  add_setting_model "gemini-3.1-pro-low" "AG: Gemini 3.1 Pro Low" "http://127.0.0.1:8045/v1" "${AG_KEY}" "openai" 4096
  add_setting_model "gemini-3-flash" "AG: Gemini 3 Flash" "http://127.0.0.1:8045/v1" "${AG_KEY}" "openai" 4096
  add_setting_model "gemini-2.5-flash" "AG: Gemini 2.5 Flash" "http://127.0.0.1:8045/v1" "${AG_KEY}" "openai" 4096
  add_setting_model "gemini-2.5-flash-lite" "AG: Gemini 2.5 Flash Lite" "http://127.0.0.1:8045/v1" "${AG_KEY}" "openai" 4096
  add_setting_model "gpt-oss-120b-medium" "AG: GPT OSS 120B Medium" "http://127.0.0.1:8045/v1" "${AG_KEY}" "openai" 4096

  add_config_model "claude-opus-4-6-thinking" "AG: Claude Opus 4.6 Thinking" "http://127.0.0.1:8045" "${AG_KEY}" "anthropic" 4096
  add_config_model "claude-sonnet-4-6" "AG: Claude Sonnet 4.6" "http://127.0.0.1:8045" "${AG_KEY}" "anthropic" 4096
  add_config_model "gemini-3-pro-high" "AG: Gemini 3 Pro High" "http://127.0.0.1:8045/v1" "${AG_KEY}" "openai" 4096
  add_config_model "gemini-3-pro-low" "AG: Gemini 3 Pro Low" "http://127.0.0.1:8045/v1" "${AG_KEY}" "openai" 4096
  add_config_model "gemini-3.1-pro-high" "AG: Gemini 3.1 Pro High" "http://127.0.0.1:8045/v1" "${AG_KEY}" "openai" 4096
  add_config_model "gemini-3.1-pro-low" "AG: Gemini 3.1 Pro Low" "http://127.0.0.1:8045/v1" "${AG_KEY}" "openai" 4096
  add_config_model "gemini-3-flash" "AG: Gemini 3 Flash" "http://127.0.0.1:8045/v1" "${AG_KEY}" "openai" 4096
  add_config_model "gemini-2.5-flash" "AG: Gemini 2.5 Flash" "http://127.0.0.1:8045/v1" "${AG_KEY}" "openai" 4096
  add_config_model "gemini-2.5-flash-lite" "AG: Gemini 2.5 Flash Lite" "http://127.0.0.1:8045/v1" "${AG_KEY}" "openai" 4096
  add_config_model "gpt-oss-120b-medium" "AG: GPT OSS 120B Medium" "http://127.0.0.1:8045/v1" "${AG_KEY}" "openai" 4096
fi

settings_json=$(printf "%b" "{\n  \"customModels\": [\n$(join_by ",\\n" "${settings_entries[@]}")\n  ]\n}\n")
config_json=$(printf "%b" "{\n  \"custom_models\": [\n$(join_by ",\\n" "${config_entries[@]}")\n  ]\n}\n")

printf "%s" "${settings_json}" > "${SETTINGS_FILE}"
printf "%s" "${config_json}" > "${CONFIG_FILE}"

echo "Done. Files updated:"
echo "- ${SETTINGS_FILE}"
echo "- ${CONFIG_FILE}"
