-- Fuzzy finder (fzf-lua).
--
-- Filtering inside the popup:
--   * live_grep (<leader>a) parses inline ripgrep globs after a ` -- ` separator, so
--     filters are typed as part of the query. Write the globs bare, one per space -
--     each whitespace-separated token is wrapped in `--iglob` for you, so a literal
--     `-g` or surrounding quotes would be taken as part of the glob:
--         useEffect -- *.tsx              only .tsx files
--         useEffect -- !*test*            everything except test files
--         useEffect -- *.ts !*.spec.ts    include + exclude together
--         useEffect -- src/**             scope to a subtree
--     Globs are case-insensitive (fzf-lua's `glob_flag` default is `--iglob`; set it
--     to `--glob` for case-sensitive globs).
--   * fzf's own query syntax filters the list that is already on screen, in every
--     picker: `!term` excludes, `'term` is an exact match, `a | b` is OR, and `^a` /
--     `a$` anchor to the start / end of the line.
--   * Keys inside a file picker: <alt-i> toggle .gitignore, <alt-h> toggle hidden
--     files, <alt-f> follow symlinks, <ctrl-g> switch between live_grep and grep.
--
-- NOTE: <alt-i> toggles ripgrep/fd's *ignore-file* handling only. It does not undo the
-- explicit `IGNORE` exclusions below - <leader>A (grep) and <leader>F (files) are the
-- unfiltered escape hatches, or re-include a path inline with `-- node_modules/**`
-- (later globs win).

-- One shared list of paths that are never worth searching. Rendered into ripgrep's
-- glob flags for grep and fd's exclude flags for files, so both pickers stay in sync.
-- Doing it in the backend is cheaper than fzf-lua's `file_ignore_patterns`, which
-- filters after the fact and is disabled under `live_grep_native`.
local IGNORE = { ".git", ".jj", "node_modules", "dist", "build", "*.lock" }

-- `prefix` goes inside the quotes with the pattern: ripgrep's negation marker is part
-- of the glob (`--iglob '!dist'`), not a separate argument.
local function flags(flag, prefix)
  local out = {}
  for _, pattern in ipairs(IGNORE) do
    table.insert(out, ("%s '%s%s'"):format(flag, prefix or "", pattern))
  end
  return table.concat(out, " ")
end

-- fzf-lua's default `grep.rg_opts`, minus the trailing `-e`. Keeping `--color=always`
-- is what highlights the matched text, and `-e` must stay last: fzf-lua relocates the
-- globs it generates to just before `-e`, and without it a query starting with `-` is
-- parsed by ripgrep as a flag.
local RG_BASE = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096"
local RG_OPTS = ("%s --hidden %s -e"):format(RG_BASE, flags("--iglob", "!"))

-- fzf-lua's default `files.fd_opts` already excludes .git and .jj; extend it with the
-- rest of the shared list.
local FD_OPTS = ("--color=never --type f --type l %s"):format(flags("--exclude"))

return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    -- "max-perf",
    grep = {
      rg_opts = RG_OPTS,
      -- Prepended to the auto-generated action hints in the popup header, so the glob
      -- syntax is visible while typing.
      interactive_header_txt = "globs: <query> -- *.lua !*test*  ",
    },
    files = {
      fd_opts = FD_OPTS,
    },
  },
  keys = {
    { "<leader>f", function() require("fzf-lua").files() end, desc = "Files (.gitignore is honored)" },
    { "<leader>F", function() require("fzf-lua").files({ cmd = "fd --type f --hidden --no-ignore --strip-cwd-prefix" }) end, desc = "All Files" },
    { "<leader>a", function() require("fzf-lua").live_grep() end,  desc = "Live grep (rg)" },
    -- Unfiltered counterpart to <leader>F: ignores .gitignore and the IGNORE list.
    { "<leader>A", function() require("fzf-lua").live_grep({ no_ignore = true, hidden = true, rg_opts = RG_BASE .. " -e" }) end, desc = "Live grep (everything)" },
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
