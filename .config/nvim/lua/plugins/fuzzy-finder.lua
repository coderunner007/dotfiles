return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    -- "max-perf",
    grep = {
      -- ripgrep options for live_grep
      rg_opts = "--hidden --line-number --column --no-heading --smart-case -g '!{.git,node_modules}'",
    },
  },
  keys = {
    { "<leader>f", function() require("fzf-lua").files() end, desc = "Files (.gitignore is honored)" },
    { "<leader>F", function() require("fzf-lua").files({ cmd = "fd --type f --hidden --no-ignore --strip-cwd-prefix" }) end, desc = "All Files" },
    { "<leader>a", function() require("fzf-lua").live_grep() end,  desc = "Live grep (rg)" },
    { "<leader>b", function() require("fzf-lua").buffers() end,    desc = "Buffers" },
    { "<leader>t", function() require("fzf-lua").tabs() end,    desc = "Tabs" },
    { "<leader>r", function() require("fzf-lua").registers() end,    desc = "Registers" },
    -- Git
    { "<leader>gs", function() require("fzf-lua").git_status() end,  desc = "Git status" },
    { "<leader>gl", function() require("fzf-lua").git_commits() end, desc = "Git commits (project)" },
    { "<leader>gb", function() require("fzf-lua").git_branches() end,desc = "Git branches" },
    { "<leader>gd", function() require("fzf-lua").git_diff() end,    desc = "Git diff" },
  },
}
