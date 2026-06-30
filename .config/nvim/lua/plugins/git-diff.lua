return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  keys = {
    { "<leader>gv", "<cmd>DiffviewOpen<CR>",        desc = "Git diff: open working tree" },
    { "<leader>gx", "<cmd>DiffviewClose<CR>",       desc = "Git diff: close" },
    { "<leader>gV", "<cmd>DiffviewOpen HEAD~1<CR>", desc = "Git diff: last commit" },
  },
}
