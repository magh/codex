# AI Provider Configuration Guide

Codex CLI supports multiple AI providers beyond OpenAI. This guide covers how to configure and use each supported provider.

## Table of Contents

- [Quick Start](#quick-start)
- [Supported Providers](#supported-providers)
  - [OpenAI](#openai)
  - [Azure OpenAI](#azure-openai)
  - [Ollama (Local)](#ollama-local)
  - [Google Gemini](#google-gemini)
  - [OpenRouter](#openrouter)
  - [Mistral](#mistral)
  - [DeepSeek](#deepseek)
  - [xAI (Grok)](#xai-grok)
  - [Groq](#groq)
  - [Custom Providers](#custom-providers)
- [Configuration Methods](#configuration-methods)
- [Troubleshooting](#troubleshooting)

## Quick Start

To use a different provider, use the `--provider` flag:

```bash
codex --provider azure --model your-deployment-name "explain this code"
```

## Supported Providers

### OpenAI

**Default provider** - no additional configuration needed if you have an OpenAI API key.

```bash
# Set API key
export OPENAI_API_KEY="sk-..."

# Use directly
codex "write a hello world program"
```

### Azure OpenAI

Azure OpenAI requires your resource endpoint and deployment name.

#### Environment Variables

```bash
export AZURE_OPENAI_API_KEY="your-azure-api-key"
export AZURE_BASE_URL="https://YOUR_RESOURCE.openai.azure.com/openai"
export AZURE_OPENAI_API_VERSION="2025-03-01-preview"  # Optional
```

#### Configuration File

Create `~/.codex/config.json`:

```json
{
  "provider": "azure",
  "model": "your-deployment-name",
  "providers": {
    "azure": {
      "name": "AzureOpenAI",
      "baseURL": "https://YOUR_RESOURCE.openai.azure.com/openai",
      "envKey": "AZURE_OPENAI_API_KEY"
    }
  }
}
```

#### Usage

```bash
# With flags
codex --provider azure --model gpt-4-deployment "your prompt"

# With config file
codex "your prompt"  # uses settings from config.json
```

### Ollama (Local)

Run models locally without API keys. See [ollama-integration.md](./ollama-integration.md) for detailed setup.

#### Quick Setup

```bash
# Install Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# Pull a model
ollama pull llama3.3

# Use with Codex
codex --provider ollama --model llama3.3 "explain this function"
```

#### Configuration

```json
{
  "provider": "ollama",
  "model": "llama3.3"
}
```

**Note**: No API key required! Ollama runs locally on `http://localhost:11434/v1`.

### Google Gemini

#### Setup

```bash
export GEMINI_API_KEY="your-gemini-api-key"
```

#### Usage

```bash
codex --provider gemini --model gemini-1.5-flash "analyze this code"
```

### OpenRouter

Access multiple models through a single API.

#### Setup

```bash
export OPENROUTER_API_KEY="sk-or-..."
```

#### Usage

```bash
codex --provider openrouter --model "anthropic/claude-3-opus" "refactor this class"
```

### Mistral

#### Setup

```bash
export MISTRAL_API_KEY="your-mistral-api-key"
```

#### Usage

```bash
codex --provider mistral --model mistral-large "optimize this algorithm"
```

### DeepSeek

Specialized in code generation and understanding.

#### Setup

```bash
export DEEPSEEK_API_KEY="your-deepseek-api-key"
```

#### Usage

```bash
codex --provider deepseek --model deepseek-coder "write unit tests"
```

### xAI (Grok)

#### Setup

```bash
export XAI_API_KEY="your-xai-api-key"
```

#### Usage

```bash
codex --provider xai --model grok-beta "explain this architecture"
```

### Groq

High-performance inference platform.

#### Setup

```bash
export GROQ_API_KEY="your-groq-api-key"
```

#### Usage

```bash
codex --provider groq --model mixtral-8x7b "debug this error"
```

### Custom Providers

You can add any OpenAI-compatible provider.

#### Method 1: Environment Variables

```bash
export CUSTOM_API_KEY="your-api-key"
export CUSTOM_BASE_URL="https://api.custom-provider.com/v1"

codex --provider custom --model model-name "your prompt"
```

#### Method 2: Configuration File

Add to `~/.codex/config.json`:

```json
{
  "provider": "custom",
  "model": "model-name",
  "providers": {
    "custom": {
      "name": "Custom Provider",
      "baseURL": "https://api.custom-provider.com/v1",
      "envKey": "CUSTOM_API_KEY"
    }
  }
}
```

## Configuration Methods

### 1. Command Line Flags (Highest Priority)

```bash
codex --provider azure --model gpt-4 "your prompt"
```

### 2. Environment Variables

```bash
export CODEX_PROVIDER=azure
export CODEX_MODEL=gpt-4
export AZURE_OPENAI_API_KEY="..."
```

### 3. Configuration File

Create `~/.codex/config.json` or `~/.codex/config.yaml`:

**JSON Format:**

```json
{
  "provider": "azure",
  "model": "gpt-4",
  "approvalMode": "suggest",
  "providers": {
    "azure": {
      "name": "AzureOpenAI",
      "baseURL": "https://YOUR_RESOURCE.openai.azure.com/openai",
      "envKey": "AZURE_OPENAI_API_KEY"
    }
  }
}
```

**YAML Format:**

```yaml
provider: azure
model: gpt-4
approvalMode: suggest
providers:
  azure:
    name: AzureOpenAI
    baseURL: https://YOUR_RESOURCE.openai.azure.com/openai
    envKey: AZURE_OPENAI_API_KEY
```

## Troubleshooting

### Missing API Key Error

If you see "Missing [PROVIDER] API key", ensure:

1. The environment variable is set correctly:

   ```bash
   echo $AZURE_OPENAI_API_KEY  # Should show your key
   ```

2. The variable name matches the provider:
   - Azure: `AZURE_OPENAI_API_KEY`
   - Gemini: `GEMINI_API_KEY`
   - OpenRouter: `OPENROUTER_API_KEY`
   - etc.

### Connection Errors

1. **Check base URL**: Ensure the base URL is correct and includes `/openai` for Azure
2. **Verify network**: Some providers may be blocked by corporate firewalls
3. **Test with curl**:
   ```bash
   curl -H "Authorization: Bearer $YOUR_API_KEY" https://api.provider.com/v1/models
   ```

### Model Not Found

- For Azure: Use your **deployment name**, not the model name
- For other providers: Check their documentation for available model names
- List available models (if supported):
  ```bash
  curl -H "Authorization: Bearer $API_KEY" https://api.provider.com/v1/models
  ```

### Performance Issues

- **Ollama**: Ensure you have enough RAM/VRAM for the model size
- **Cloud providers**: Consider using a region closer to you
- **Large models**: Try smaller variants (e.g., `mistral-7b` instead of `mixtral-8x7b`)

## Best Practices

1. **Security**: Never commit API keys to version control
2. **Cost Management**: Be aware of pricing differences between providers
3. **Model Selection**: Choose models appropriate for your task:
   - Code generation: DeepSeek Coder, Code Llama
   - General tasks: GPT-4, Claude, Gemini
   - Fast responses: Groq, smaller models
4. **Local Development**: Use Ollama for offline work or sensitive code

## Provider Feature Comparison

| Provider | API Key Required | Local Option | Best For                       |
| -------- | ---------------- | ------------ | ------------------------------ |
| OpenAI   | Yes              | No           | General purpose, latest models |
| Azure    | Yes              | No           | Enterprise, compliance         |
| Ollama   | No               | Yes          | Privacy, offline work          |
| Gemini   | Yes              | No           | Google ecosystem integration   |
| DeepSeek | Yes              | No           | Code-specific tasks            |
| Groq     | Yes              | No           | Fast inference                 |

## Examples

### Multi-provider Workflow

```bash
# Use Ollama for local development
codex --provider ollama --model codellama "create a test file"

# Use GPT-4 for complex reasoning
codex --provider openai --model gpt-4 "architect a microservice"

# Use Azure for production
codex --provider azure --model prod-gpt4 "deploy to kubernetes"
```

### Switching Providers Dynamically

```bash
# Set default provider in config
echo '{"provider": "ollama", "model": "llama3.3"}' > ~/.codex/config.json

# Override for specific tasks
codex --provider openai --model o3-mini "complex analysis"
```

For more details on a specific provider, check their official documentation or the [Codex CLI documentation](https://github.com/openai/codex).
