#!/usr/bin/env bash
set -euo pipefail

FACTORY_DIR="${HOME}/.factory"
SETTINGS_FILE="${FACTORY_DIR}/settings.json"
CONFIG_FILE="${FACTORY_DIR}/config.json"

mkdir -p "${FACTORY_DIR}"

echo "BYOK setup for Factory Droid"

echo "Select providers to configure:"

ask_yes_no() {
  local prompt="$1"
  local default_no="${2:-true}"
  local ans
  while true; do
    if [[ "${default_no}" == "true" ]]; then
      read -r -p "${prompt} [y/N]: " ans
    else
      read -r -p "${prompt} [Y/n]: " ans
    fi
    ans=${ans:-"${default_no}"}
    case "${ans}" in
      y|Y|yes|YES|false) return 0 ;;
      n|N|no|NO|true) return 1 ;;
      *) echo "Please answer y or n." ;;
    esac
  done
}

read_default() {
  local prompt="$1"
  local def="$2"
  local val
  read -r -p "${prompt} [${def}]: " val
  if [[ -z "${val}" ]]; then
    printf "%s" "${def}"
  else
    printf "%s" "${val}"
  fi
}

SELECT_VP=false
SELECT_AG=false
SELECT_ZAI=false
SELECT_MINIMAX=false
SELECT_KIMI=false

if ask_yes_no "Configure VibeProxy"; then SELECT_VP=true; fi
if ask_yes_no "Configure Antigravity Manager"; then SELECT_AG=true; fi
if ask_yes_no "Configure Z.AI GLM"; then SELECT_ZAI=true; fi
if ask_yes_no "Configure MiniMax"; then SELECT_MINIMAX=true; fi
if ask_yes_no "Configure Kimi"; then SELECT_KIMI=true; fi

if ! ${SELECT_VP} && ! ${SELECT_AG} && ! ${SELECT_ZAI} && ! ${SELECT_MINIMAX} && ! ${SELECT_KIMI}; then
  echo "No providers selected. Exiting."
  exit 0
fi

VP_PORT=""
AG_PORT=""
VP_KEY=""
AG_KEY=""
ZAI_KEY=""
MINIMAX_KEY=""
KIMI_KEY=""
KIMI_BASE_URL=""
KIMI_PROVIDER=""

if ${SELECT_VP}; then
  VP_PORT=$(read_default "VibeProxy port" "8317")
  read -r -s -p "VibeProxy token (manual input): " VP_KEY
  printf "\n"
fi

if ${SELECT_AG}; then
  AG_PORT=$(read_default "Antigravity port" "8045")
  read -r -s -p "Antigravity API key (manual input): " AG_KEY
  printf "\n"
fi

if ${SELECT_ZAI}; then
  read -r -s -p "Z.AI API key (manual input): " ZAI_KEY
  printf "\n"
fi

if ${SELECT_MINIMAX}; then
  read -r -s -p "MiniMax API key (manual input): " MINIMAX_KEY
  printf "\n"
fi

if ${SELECT_KIMI}; then
  read -r -s -p "Kimi API key (manual input): " KIMI_KEY
  printf "\n"
  KIMI_BASE_URL=$(read_default "Kimi base URL" "<KIMI_BASE_URL>")
  KIMI_PROVIDER=$(read_default "Kimi provider (openai/anthropic/generic-chat-completion-api)" "openai")
fi

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

add_model_both() {
  local model="$1" display="$2" base="$3" key="$4" provider="$5" max="$6"
  add_setting_model "${model}" "${display}" "${base}" "${key}" "${provider}" "${max}"
  add_config_model "${model}" "${display}" "${base}" "${key}" "${provider}" "${max}"
}

join_by() {
  local IFS="$1"
  shift
  printf "%s" "$*"
}

select_model() {
  local label="$1"
  if ask_yes_no "Include ${label}"; then
    return 0
  fi
  return 1
}

if ${SELECT_ZAI}; then
  if select_model "GLM 4.7"; then
    add_model_both "glm-4.7" "GLM 4.7" "https://api.z.ai/api/coding/paas/v4" "${ZAI_KEY}" "generic-chat-completion-api" 131072
  fi
  if select_model "GLM 4.7 Flash"; then
    add_model_both "glm-4.7-flash" "GLM 4.7 Flash" "https://api.z.ai/api/coding/paas/v4" "${ZAI_KEY}" "generic-chat-completion-api" 131072
  fi
  if select_model "GLM 5"; then
    add_model_both "glm-5" "GLM 5" "https://api.z.ai/api/coding/paas/v4" "${ZAI_KEY}" "generic-chat-completion-api" 131072
  fi
fi

if ${SELECT_MINIMAX}; then
  if select_model "MiniMax M2.5"; then
    add_model_both "MiniMax-M2.5" "MiniMax M2.5" "https://api.minimax.io/anthropic" "${MINIMAX_KEY}" "anthropic" 16384
  fi
fi

if ${SELECT_KIMI}; then
  if select_model "Kimi K2"; then
    add_model_both "kimi-k2" "Kimi K2" "${KIMI_BASE_URL}" "${KIMI_KEY}" "${KIMI_PROVIDER}" 4096
  fi
fi

if ${SELECT_VP}; then
  if [[ -z "${VP_KEY}" ]]; then
    echo "VibeProxy token is required for VibeProxy models."
    exit 1
  fi
  VP_ANTHROPIC_BASE="http://127.0.0.1:${VP_PORT}"
  VP_OPENAI_BASE="http://127.0.0.1:${VP_PORT}/v1"

  if select_model "VP: Claude Opus 4.6 Thinking"; then
    add_model_both "claude-opus-4-6-thinking" "VP: Claude Opus 4.6 Thinking" "${VP_ANTHROPIC_BASE}" "${VP_KEY}" "anthropic" 4096
  fi
  if select_model "VP: Claude Sonnet 4.6"; then
    add_model_both "claude-sonnet-4-6" "VP: Claude Sonnet 4.6" "${VP_ANTHROPIC_BASE}" "${VP_KEY}" "anthropic" 4096
  fi
  if select_model "VP: Gemini 3 Pro High"; then
    add_model_both "gemini-3-pro-high" "VP: Gemini 3 Pro High" "${VP_OPENAI_BASE}" "${VP_KEY}" "openai" 4096
  fi
  if select_model "VP: Gemini 3 Pro Low"; then
    add_model_both "gemini-3-pro-low" "VP: Gemini 3 Pro Low" "${VP_OPENAI_BASE}" "${VP_KEY}" "openai" 4096
  fi
  if select_model "VP: Gemini 3.1 Pro High"; then
    add_model_both "gemini-3.1-pro-high" "VP: Gemini 3.1 Pro High" "${VP_OPENAI_BASE}" "${VP_KEY}" "openai" 4096
  fi
  if select_model "VP: Gemini 3.1 Pro Low"; then
    add_model_both "gemini-3.1-pro-low" "VP: Gemini 3.1 Pro Low" "${VP_OPENAI_BASE}" "${VP_KEY}" "openai" 4096
  fi
  if select_model "VP: Gemini 3 Flash"; then
    add_model_both "gemini-3-flash" "VP: Gemini 3 Flash" "${VP_OPENAI_BASE}" "${VP_KEY}" "openai" 4096
  fi
  if select_model "VP: Gemini 2.5 Flash"; then
    add_model_both "gemini-2.5-flash" "VP: Gemini 2.5 Flash" "${VP_OPENAI_BASE}" "${VP_KEY}" "openai" 4096
  fi
  if select_model "VP: Gemini 2.5 Flash Lite"; then
    add_model_both "gemini-2.5-flash-lite" "VP: Gemini 2.5 Flash Lite" "${VP_OPENAI_BASE}" "${VP_KEY}" "openai" 4096
  fi
  if select_model "VP: GPT OSS 120B Medium"; then
    add_model_both "gpt-oss-120b-medium" "VP: GPT OSS 120B Medium" "${VP_OPENAI_BASE}" "${VP_KEY}" "openai" 4096
  fi
fi

if ${SELECT_AG}; then
  if [[ -z "${AG_KEY}" ]]; then
    echo "Antigravity API key is required for Antigravity models."
    exit 1
  fi
  AG_ANTHROPIC_BASE="http://127.0.0.1:${AG_PORT}"
  AG_OPENAI_BASE="http://127.0.0.1:${AG_PORT}/v1"

  if select_model "AG: Claude Opus 4.6 Thinking"; then
    add_model_both "claude-opus-4-6-thinking" "AG: Claude Opus 4.6 Thinking" "${AG_ANTHROPIC_BASE}" "${AG_KEY}" "anthropic" 4096
  fi
  if select_model "AG: Claude Sonnet 4.6"; then
    add_model_both "claude-sonnet-4-6" "AG: Claude Sonnet 4.6" "${AG_ANTHROPIC_BASE}" "${AG_KEY}" "anthropic" 4096
  fi
  if select_model "AG: Gemini 3 Pro High"; then
    add_model_both "gemini-3-pro-high" "AG: Gemini 3 Pro High" "${AG_OPENAI_BASE}" "${AG_KEY}" "openai" 4096
  fi
  if select_model "AG: Gemini 3 Pro Low"; then
    add_model_both "gemini-3-pro-low" "AG: Gemini 3 Pro Low" "${AG_OPENAI_BASE}" "${AG_KEY}" "openai" 4096
  fi
  if select_model "AG: Gemini 3.1 Pro High"; then
    add_model_both "gemini-3.1-pro-high" "AG: Gemini 3.1 Pro High" "${AG_OPENAI_BASE}" "${AG_KEY}" "openai" 4096
  fi
  if select_model "AG: Gemini 3.1 Pro Low"; then
    add_model_both "gemini-3.1-pro-low" "AG: Gemini 3.1 Pro Low" "${AG_OPENAI_BASE}" "${AG_KEY}" "openai" 4096
  fi
  if select_model "AG: Gemini 3 Flash"; then
    add_model_both "gemini-3-flash" "AG: Gemini 3 Flash" "${AG_OPENAI_BASE}" "${AG_KEY}" "openai" 4096
  fi
  if select_model "AG: Gemini 2.5 Flash"; then
    add_model_both "gemini-2.5-flash" "AG: Gemini 2.5 Flash" "${AG_OPENAI_BASE}" "${AG_KEY}" "openai" 4096
  fi
  if select_model "AG: Gemini 2.5 Flash Lite"; then
    add_model_both "gemini-2.5-flash-lite" "AG: Gemini 2.5 Flash Lite" "${AG_OPENAI_BASE}" "${AG_KEY}" "openai" 4096
  fi
  if select_model "AG: GPT OSS 120B Medium"; then
    add_model_both "gpt-oss-120b-medium" "AG: GPT OSS 120B Medium" "${AG_OPENAI_BASE}" "${AG_KEY}" "openai" 4096
  fi
fi

settings_json=$(printf "%b" "{\n  \"customModels\": [\n$(join_by ",\\n" "${settings_entries[@]}")\n  ]\n}\n")
config_json=$(printf "%b" "{\n  \"custom_models\": [\n$(join_by ",\\n" "${config_entries[@]}")\n  ]\n}\n")

printf "%s" "${settings_json}" > "${SETTINGS_FILE}"
printf "%s" "${config_json}" > "${CONFIG_FILE}"

echo "Done. Files updated:"
echo "- ${SETTINGS_FILE}"
echo "- ${CONFIG_FILE}"
