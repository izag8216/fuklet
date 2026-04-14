# Contributing to fuklet

Thank you for your interest in contributing to fuklet!

## How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feat/your-feature`)
3. Make your changes
4. Test your changes (see below)
5. Commit with conventional commits (`feat:`, `fix:`, `docs:`, etc.)
6. Push and open a Pull Request

## Testing

```bash
# Lint shell scripts
shellcheck skill/generate.sh

# Run generate.sh with test fixtures
mkdir -p /tmp/fuklet-test
echo "# Test File 1" > /tmp/fuklet-test/test1.md
echo "# Test File 2" > /tmp/fuklet-test/test2.md
./skill/generate.sh /tmp/fuklet-test

# Verify output HTML is well-formed
```

## Code Style

- Shell scripts: Follow [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- HTML/CSS: 2-space indentation
- JavaScript: No semicolons, single quotes, 2-space indentation
- CSS custom properties for all fuku brand colors

## Reporting Issues

Use the [bug report](.github/ISSUE_TEMPLATE/bug_report.md) or [feature request](.github/ISSUE_TEMPLATE/feature_request.md) templates.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
