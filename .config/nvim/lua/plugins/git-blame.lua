return {
  "FabijanZulj/blame.nvim",
  cmd = { "BlameToggle" },
  opts = {
    date_format = "%d/%m/%Y",
  },
  keys = {
    { "<leader>gB", "<cmd>BlameToggle<cr>", desc = "Toggle blame sidebar" },
  },
}
