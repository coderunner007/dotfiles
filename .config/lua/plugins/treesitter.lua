-- Each file returns a list (or a single table) of specs
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    -- lazy = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },   -- lazy-load on open
    -- With `opts` only, lazy.nvim will call the plugin's setup for you.
    -- For nvim-treesitter that means: require("nvim-treesitter.configs").setup(opts)
    -- (no manual config() needed)
    opts = {
      ensure_installed = {
        "lua", "vim", "vimdoc", "bash", "python", "json", "yaml", "fish",
        "markdown", "markdown_inline", "html", "css", "javascript", "go",
	"typescript"
      },
      auto_install = false,
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = { enable = true },
      -- incremental_selection = {
      --   enable = true,
      --   keymaps = {
      --     init_selection = "<CR>",
      --     node_incremental = "<CR>",
      --     scope_incremental = "<S-CR>",
      --     node_decremental = "<BS>",
      --   },
      -- },
    },
  },
}

