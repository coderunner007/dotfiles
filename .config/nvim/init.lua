-- Leader key ──────────────────────────────
vim.g.mapleader = " "
vim.g.maplocalleader = " " -- optional: for <localleader>
-- Open lazy.nvim & mason.nvim
vim.keymap.set("n", "<leader>l", "<cmd>Lazy<CR>", { desc = "Lazy: open UI", silent = true })
vim.keymap.set("n", "<leader>m", "<cmd>Mason<CR>", { desc = "Mason: open UI", silent = true })
vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<CR>", { desc = "Toggle ZenMode", silent = true })


-- Plugins ─────────────────────────────────
require("config.lazy")

-- Line numbers ─────────────────────────────
vim.opt.number = true          -- show absolute line number on the current line
vim.opt.relativenumber = false -- show relative line numbers on other lines

-- Tabs ─────────────────────────────────────
-- Global defaults: 2 spaces per tab
vim.opt.tabstop = 2      -- how many spaces a tab counts for
vim.opt.shiftwidth = 2   -- spaces per indentation level
vim.opt.softtabstop = 2  -- spaces per <Tab>/<BS>
vim.opt.expandtab = true -- convert <Tab> to spaces

-- override for specific languages
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = false -- Go convention: real tabs
  end,
})

-- Always use UTF-8 ─────────────────────────
-- vim.opt.encoding = "utf-8"
-- vim.opt.fileencoding = "utf-8"

-- Matching brackets navigation ─────────────
vim.cmd("packadd matchit")

-- Search ───────────────────────────────────
-- Case handling
vim.opt.ignorecase = true         -- case-insensitive…
vim.opt.smartcase  = true         -- …unless pattern has capitals
-- Live feedback
vim.opt.incsearch  = true         -- show matches as you type
vim.opt.hlsearch   = true         -- highlight matches
-- Search quality-of-life
vim.opt.wrapscan   = true         -- wrap around file when reaching end
vim.opt.foldopen:append("search") -- open folds when jumping to a match
vim.opt.inccommand = "split"      -- preview :%s/// substitutions
-- Use ripgrep for :grep (fast, respects .gitignore)
vim.opt.grepprg    = "rg --vimgrep --hidden"
vim.opt.grepformat = "%f:%l:%c:%m"
-- Disable highlights
vim.keymap.set("n", "<leader>;", "<Cmd>nohlsearch<CR>", {
  desc = "Clear search highlight",
  silent = true,
})

-- Misc ─────────────────────────────────────
-- Folding
vim.opt.foldmethod = "syntax" -- same as: set foldmethod=syntax
-- vim.opt.foldlevelstart = 10   -- open most folds by default
-- vim.opt.foldnestmax = 10      -- 10 nested folds max
vim.opt.foldlevel = 0 -- start with all folds closed
-- History
vim.opt.history = 200
-- UI
vim.opt.cursorline = true -- highlight current line
-- Command-line completion (wildmenu)
vim.opt.wildmenu = true   -- show wildmenu
-- Optional modern behavior:
vim.opt.wildmode = "longest:full,full"
vim.opt.wildoptions = "pum,fuzzy" -- popup menu + fuzzy match (Neovim feature)
-- Tabs
vim.keymap.set("n", "th", "<cmd>tabprevious<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "tl", "<cmd>tabnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "tq", "<cmd>tabclose<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "to", "<cmd>tabedit<CR>", { noremap = true, silent = true }) -- = :tabe

-- Copy filepath + line number(s) to system clipboard ────
local function copy_location_to_clipboard()
  local filepath = vim.fn.expand("%:p")
  local mode = vim.fn.mode()
  local line_start, line_end

  if mode == "v" or mode == "V" or mode == "\22" then
    -- Visual block mode (\22 = Ctrl+V)
    line_start = vim.fn.line("v")
    line_end   = vim.fn.line(".")
    if line_start > line_end then
      line_start, line_end = line_end, line_start
    end
  else
    -- Normal mode: just current line
    line_start = vim.fn.line(".")
    line_end   = line_start
  end

  local text = line_start == line_end
    and string.format("%s:%d", filepath, line_start)
    or  string.format("%s:L%d-L%d", filepath, line_start, line_end)

  vim.fn.setreg("+", text)
  vim.notify("Copied: " .. text, vim.log.levels.INFO)
end

vim.keymap.set({ "n", "v" }, "<leader>c", copy_location_to_clipboard, {
  desc = "Copy filepath + line(s) to clipboard",
  silent = true,
})
