return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional
  opts = {
    default_file_explorer = true,
    delete_to_trash = false,
    view_options = {
      show_hidden = true,
      show_parent_dir = true, -- add ".."
    },
    keymaps = {
      ["<CR>"] = "actions.select",
      ["o"] = "actions.select",
      ["_"] = "actions.parent",
      ["q"] = "actions.close",
      ["I"] = "actions.toggle_hidden",   -- toggle dotfiles
    },
  },
  -- keys = {
  --   { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
  --   { "<leader>e", function() require("oil").open(vim.fn.getcwd()) end,
  --     desc = "Open Oil at project root" },
  -- },
}
