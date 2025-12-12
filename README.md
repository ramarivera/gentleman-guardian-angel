# AI Code Review

> Provider-agnostic code review using AI. Works with Claude, Gemini, Codex, Ollama, and more.

A standalone CLI tool that validates your staged files against your project's coding standards using any AI provider. No dependencies on Husky or any specific framework.

## Features

- **Provider Agnostic**: Use whichever AI you have installed (Claude, Gemini, Codex, Ollama)
- **Zero Dependencies**: Pure Bash, works on any Unix system
- **Git Hook Integration**: Automatic review on every commit
- **Configurable**: File patterns, exclusions, custom rules file
- **Strict Mode**: Fail builds on ambiguous AI responses

## Supported Providers

| Provider | Command Used | Installation |
|----------|-------------|--------------|
| Claude | `claude` | [claude.ai/code](https://claude.ai/code) |
| Gemini | `gemini` | `npm i -g @google/gemini-cli` |
| Codex | `codex exec` | `npm i -g @openai/codex` |
| Ollama | `ollama run <model>` | [ollama.ai](https://ollama.ai) |

## Installation

```bash
git clone https://github.com/your-org/ai-code-review.git
cd ai-code-review
./install.sh
```

Or manually:

```bash
# Copy to your PATH
cp bin/ai-code-review /usr/local/bin/
cp -r lib ~/.local/share/ai-code-review/
chmod +x /usr/local/bin/ai-code-review
```

## Quick Start

```bash
# 1. Navigate to your project
cd /path/to/your/project

# 2. Initialize config
ai-code-review init

# 3. Create your coding standards file
# Edit AGENTS.md with your rules

# 4. Install git hook
ai-code-review install

# 5. Done! Reviews run automatically on commit
```

## Configuration

Create `.ai-code-review` in your project root:

```bash
# AI Provider (required)
# Options: claude, gemini, codex, ollama:<model>
PROVIDER="claude"

# File patterns to include (comma-separated)
FILE_PATTERNS="*.ts,*.tsx,*.js,*.jsx"

# File patterns to exclude (comma-separated)
EXCLUDE_PATTERNS="*.test.ts,*.spec.ts,*.d.ts"

# File containing review rules
RULES_FILE="AGENTS.md"

# Fail on ambiguous AI response
STRICT_MODE="true"
```

### Global Config

For settings that apply to all your projects:

```bash
mkdir -p ~/.config/ai-code-review
# Create ~/.config/ai-code-review/config with same format
```

### Environment Variables

Override any setting with environment variables:

```bash
AI_CODE_REVIEW_PROVIDER="gemini" ai-code-review run
```

## Rules File (AGENTS.md)

Create an `AGENTS.md` file with your coding standards:

```markdown
# Code Review Rules

## TypeScript
- Use `const` and `let`, never `var`
- No `any` types - use proper typing
- Prefer interfaces over type aliases for objects

## React
- Use functional components with hooks
- No `import * as React`
- Use named exports for components

## Testing
- All new features must have tests
- Use descriptive test names

## Accessibility
- All images must have alt text
- Use semantic HTML elements
```

The AI will validate your staged files against these rules.

## Commands

```bash
ai-code-review run        # Run review manually
ai-code-review install    # Install git hook
ai-code-review uninstall  # Remove git hook
ai-code-review config     # Show current config
ai-code-review init       # Create sample config
ai-code-review help       # Show help
ai-code-review version    # Show version
```

## How It Works

1. On `git commit`, the pre-commit hook runs
2. Gets list of staged files matching your patterns
3. Reads your rules from `AGENTS.md`
4. Sends files + rules to your configured AI provider
5. AI responds with `STATUS: PASSED` or `STATUS: FAILED`
6. If failed, commit is blocked with violation details

## Examples

### TypeScript/React Project

```bash
# .ai-code-review
PROVIDER="claude"
FILE_PATTERNS="*.ts,*.tsx"
EXCLUDE_PATTERNS="*.test.ts,*.test.tsx,*.d.ts"
```

### Python Project

```bash
# .ai-code-review
PROVIDER="ollama:codellama"
FILE_PATTERNS="*.py"
EXCLUDE_PATTERNS="*_test.py,test_*.py"
```

### Go Project

```bash
# .ai-code-review
PROVIDER="gemini"
FILE_PATTERNS="*.go"
EXCLUDE_PATTERNS="*_test.go"
```

### Multi-language Project

```bash
# .ai-code-review
PROVIDER="claude"
FILE_PATTERNS="*.ts,*.tsx,*.py,*.go"
EXCLUDE_PATTERNS="*.test.ts,*_test.py,*_test.go"
```

## Bypass Review

To skip review for a specific commit:

```bash
git commit --no-verify -m "your message"
```

## Troubleshooting

### "Provider not found"

Make sure the CLI for your provider is installed and in your PATH:

```bash
which claude   # Should show path
which gemini   # Should show path
which codex    # Should show path
which ollama   # Should show path
```

### "Rules file not found"

Create an `AGENTS.md` file in your project root with your coding standards.

### "Ambiguous response" in Strict Mode

The AI response must start with `STATUS: PASSED` or `STATUS: FAILED`. If your AI is not following this format, you can:

1. Try a different provider
2. Set `STRICT_MODE="false"` to allow ambiguous responses

## Uninstallation

```bash
# Remove from current project
ai-code-review uninstall

# Remove globally
./uninstall.sh
```

## License

MIT
