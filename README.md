# Navigator.nvim

A minimalist Neovim plugin for file navigation, built because I needed a faster alternative to [ThePrimeagen’s Harpoon](https://github.com/ThePrimeagen/harpoon). When working on a network file system, Harpoon’s constant writing to save cursor positions slowed things down too much. Navigator skips that overhead, focusing on simple bookmarking and jumping between files in your current directory.

## Highlights

- Bookmark files without cursor position tracking.
- Saves bookmarks between sessions and per folder.
- Floating window for managing bookmarks.
- Optional lualine integration with custom labels.
- No default keybindings—you decide how to use it.

## Commands

- `:NavOpen` - Show the bookmark window.
- `:NavAdd` - Bookmark the current file.
- `:NavClear` - Wipe all bookmarks.
- `:NavPrint` - Debug the bookmark list.

## Installation

### With [Lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
return {
  {
    "leosmaia21/navigator.nvim",
    config = function()
      require("navigator").setup({
        showjumpkeys = true,
        lualine_keys = {"q", "w", "e", "r"},
      })
      -- Example keymaps (set your own):
      vim.keymap.set("n", "<leader>n", ":NavOpen<CR>", { desc = "Open Navigator" })
      vim.keymap.set("n", "<leader>a", ":NavAdd<CR>", { desc = "Add file" })
      vim.keymap.set("n", "<leader>q", function() require("navigator").goto(1) end, { desc = "Go to file q" })
    end,
    cmd = { "NavOpen", "NavAdd", "NavClear", "NavPrint" },
    dependencies = { "nvim-lualine/lualine.nvim" }, -- Optional
  },
}
```

### Optional lualine setup

For integrating Navigator.nvim with [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim), you can add the following configuration:

```lua
require("lualine").setup({
  sections = {
    lualine_c = { require("navigator").lualine },
  },
})
```

This will display Navigator's bookmarks in the lualine status bar.

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests to improve the plugin.

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgments

Navigator.nvim was born out of a need for simplicity and speed. It strips away unnecessary features and focuses on what matters most: navigating your workspace with ease.

---

Happy navigating! 🚀
