# Using Ollama with Codex CLI

Codex CLI has built-in support for Ollama, allowing you to use locally-running language models instead of cloud-based providers.

## Prerequisites

1. Install Ollama from [ollama.ai](https://ollama.ai)
2. Pull a model that supports chat completions:
   ```bash
   ollama pull llama3.3
   # or any other model like codellama, mistral, etc.
   ```
3. Ensure Ollama is running (it starts automatically on most systems)

## Configuration

### Method 1: Command Line Flag

Use the `--provider` flag when running codex:

```bash
codex --provider ollama --model llama3.3 "explain this codebase"
```

### Method 2: Configuration File

Create or update `~/.codex/config.json`:

```json
{
  "provider": "ollama",
  "model": "llama3.3",
  "approvalMode": "suggest"
}
```

Or if you prefer YAML (`~/.codex/config.yaml`):

```yaml
provider: ollama
model: llama3.3
approvalMode: suggest
```

### Method 3: Environment Variables

You can also set the provider via environment variables:

```bash
export CODEX_PROVIDER=ollama
export CODEX_MODEL=llama3.3
codex "fix the bug in main.js"
```

## Important Notes

1. **No API Key Required**: Unlike cloud providers, Ollama doesn't require an API key since it runs locally.

2. **Default URL**: Ollama runs on `http://localhost:11434/v1` by default. If you're running Ollama on a different port or host, you can override it:

   ```bash
   export OLLAMA_BASE_URL="http://your-host:port/v1"
   ```

3. **Model Compatibility**: Not all Ollama models may work perfectly with Codex's function calling features. Models specifically trained for code generation (like CodeLlama) tend to work better.

4. **Performance**: Local models may be slower than cloud-based alternatives, especially on machines without dedicated GPUs.

## Example Usage

```bash
# Interactive mode with Ollama
codex --provider ollama --model llama3.3

# Non-interactive mode
codex --provider ollama --model codellama:13b "write unit tests for utils.js"

# With full auto approval (be cautious with local models)
codex --provider ollama --model mistral --approval-mode auto-edit "refactor the database module"
```

## Troubleshooting

1. **Connection Refused**: Make sure Ollama is running:

   ```bash
   ollama serve
   ```

2. **Model Not Found**: Ensure you've pulled the model:

   ```bash
   ollama list  # Check available models
   ollama pull <model-name>  # Pull if missing
   ```

3. **Slow Performance**: Consider using smaller models or upgrading your hardware. Models with "7b" or "13b" in the name are generally faster than larger variants.

## Custom Ollama Configuration

If you need to customize Ollama's behavior further, you can add it to your config file:

```json
{
  "provider": "ollama",
  "model": "llama3.3",
  "providers": {
    "ollama": {
      "name": "Ollama",
      "baseURL": "http://localhost:11434/v1",
      "envKey": null
    }
  }
}
```

This allows you to point to a remote Ollama instance or use a non-standard port.
