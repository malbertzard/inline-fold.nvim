# inline-fold.nvim

`inline-fold.nvim` is a Neovim plugin inspired by the vscode plugin `inline-fold`. It provides a convenient way to make complex CSS classes, especially those with Tailwind CSS, more readable by folding the class content and displaying a placeholder.

**Note: The plugin now uses conceal and needs to be reapplied on every change to the class field. It also doesn't work for multiline classes.**

## Features ✨

- Toggle folding of the content within CSS class attributes. ↔️
- Replace the folded content with a placeholder (*) for improved readability.

## Installation 💻

Use your preferred plugin manager to install `inline-fold.nvim`.

### Plug

```lua
{
  "malbertzard/inline-fold.nvim",

  -- Optional
  opts = {
    placeholder = "…", -- Add here your char NO STRING
  }
}
```

## Usage

Once installed, the plugin provides the following functionality:

### Commands

- `InlineFoldToggle`: Toggles the folding of the content within CSS class attributes.

### Todo List 📝

- [x] Check performance for large files.
- [x] Add customizability options for the placeholder character.
- [x] Automatically reveal if the cursor enters the placeholder.

## License

This project is licensed under the MIT License.

