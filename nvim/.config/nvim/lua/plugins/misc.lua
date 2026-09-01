return {
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "tpope/vim-surround", event = "VeryLazy" },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true,
    opts = {
      -- General
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      disable_in_macro = true,          -- don't add pairs while recording/executing macros
      disable_in_visualblock = true,    -- less surprise in visual-block edits
      enable_check_bracket_line = true, -- avoid inserting a second ) if one already exists on the line
      enable_afterquote = true,         -- add pairs even after quotes: e.g. `foo' -> `foo'()`
      enable_bracket_in_quote = true,   -- allow () [] {} inside quotes
      break_undo = true,                -- make each pair insertion a separate undo step
      -- Treesitter-aware (prevents pairing inside comments/strings for supported langs)
      check_ts = true,
    },
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  }
}

