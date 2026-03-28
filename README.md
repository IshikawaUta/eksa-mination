# Eksa-Mination 🚀

A robust, modular, and feature-rich Ruby testing framework inspired by RSpec.

Eksa-Mination provides a familiar DSL for writing expressive tests, comprehensive mocking/stubbing capabilities, and powerful reporting tools—all in a lightweight package.

## ✨ Features

- **Fluent DSL**: `describe`, `it`, `let`, `let!`, `subject`, and `shared_examples`.
- **Flexible Matchers**: `eq`, `be_a`, `respond_to`, `include`, `match`, `raise_error`, and more.
- **Advanced Mocking**: Method stubbing (`allow().to receive()`) and **Constant Stubbing** (`stub_const`).
- **Powerful Filtering**: Run tests by name (`-e`), line number (`file:line`), or **Metadata Tags** (`--tag`).
- **Rich Reporting**: Built-in formatters for **Progress**, **Documentation**, **JSON**, and **HTML** (Premium Dark Mode).
- **Configuration**: Automatic loading of defaults from `.eksa-mination`.

## 🚀 Getting Started

### Installation
Install it as a gem:

```bash
gem install eksa-mination
```

Or clone this repository directly to your project.

### Running Tests
By default, Eksa-Mination looks for files matching `spec/**/*_spec.rb`.

```bash
# Run all tests
eksa-mination

# Run with Documentation formatter
eksa-mination -f documentation

# Run a specific line
eksa-mination spec/my_spec.rb:15

# Filter by Tag
eksa-mination --tag focus

# Generate HTML Report
eksa-mination -f html
```

## 📋 Project Structure

- `bin/`: The primary executable.
- `lib/eksa-mination`: Core logic, matchers, and formatters.
- `spec/`: Example testing files and usage demonstrations.

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.