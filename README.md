# inline-fold.nvim

`inline-fold.nvim` is a Neovim plugin inspired by the vscode plugin `inline-fold`. It provides a convenient way to define patterns in files that get concealed inline. This can be used for many things for example for CSS classes in HTML files especially with TailwindCSS

**Note: It doesn't work for multiline patterns.**

## Features ✨

- Toggle folding of the content
- Replace the folded content with a placeholder for improved readability.
- Placeholder can be defined by the user per pattern
- pattern can be easily added

## Installation 💻

Use your preferred plugin manager to install `inline-fold.nvim`.

### Plug

```lua
{
  "malbertzard/inline-fold.nvim",

  opts = {
    defaultPlaceholder = "…",
    queries = {

      -- Some examples you can use
      html = {
        { pattern = 'class="([^"]*)"', placeholder = "@" }, -- classes in html
        { pattern = 'href="(.-)"' }, -- hrefs in html
        { pattern = 'src="(.-)"' }, -- HTML img src attribute
      }
    },
  }
}
```

## Usage

Once installed, the plugin provides the following functionality:

### Commands

- `InlineFoldToggle`: Toggles the folding of the content within CSS class attributes.

### Call `InlineFoldToggle` via `autocmd`

Add the following snippet to your configurations to call `InlineFoldToggle` automatically based on filename patterns.
```lua
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { '*.html', '*.tsx' },
  callback = function(_)
    if not require('inline-fold.module').isHidden then
      vim.cmd('InlineFoldToggle')
    end
  end,
})
```

### Todo List 📝

- [ ] Check if moving to Treesitter is viable
- [ ] Create some sub commands for updating and removing conceals
- [ ] Record showcase

## License

This project is licensed under the MIT License.

