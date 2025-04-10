# Development Guidelines

## Testing

### Running Tests

To run the tests:

```bash
cargo test
```

To run a specific test:

```bash
cargo test test_name
```

To run tests with output:

```bash
cargo test -- --nocapture
```

### Writing Tests

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_something() {
        // Arrange
        let expected = true;

        // Act
        let result = some_function();

        // Assert
        assert_eq!(result, expected);
    }
}
```

## Code Style

- Follow the official Rust style guide
- Use `cargo fmt` to format your code
- Use `cargo clippy` for additional linting
- Use meaningful variable names
- Write documentation comments for public functions and types
- Keep functions small and focused
- Follow SOLID principles where applicable

## Pull Request Process

1. Create a new branch from `main`
2. Make your changes
3. Run `cargo fmt` and `cargo clippy`
4. Run all tests
5. Push your changes
6. Create a Pull Request
7. Wait for review

## Commit Messages

Format your commit messages following these guidelines:

```
<type>(<scope>): <subject>

<body>

<footer>
```

- Types: feat, fix, docs, style, refactor, test, chore
- Scope: Optional, describes what part of the codebase is affected
- Subject: Short description in present tense
- Body: Optional detailed description
- Footer: Optional, references to issues/PRs

Example:
```
feat(parser): add support for custom tokens

- Implemented new token parser
- Added tests for custom tokens
- Updated documentation

Closes #123
```

## Dependencies

- Add new dependencies with clear justification
- Keep dependencies up to date using `cargo update`
- Review security advisories regularly using `cargo audit`
