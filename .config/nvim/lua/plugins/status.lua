-- lua/plugins/lualine.lua
return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- You can add: event = "VeryLazy", if you want to lazy-load it
    config = function()
      -- ==== begin: slanted-gaps example (adapted for Lazy.nvim) ====

      local colors = {
        red         = "#ca1243",
        white       = "#f3f3f3",
        orange      = "#fe8019",
      }

      -- Empty component used to create the angled "gaps"
      local Empty = require("lualine.component"):extend()
      function Empty:draw(default_highlight)
        self.status = ""
        self.applied_separator = ""
        self:apply_highlights(default_highlight)
        self:apply_section_separators()
        return self.status
      end

      -- Insert separators and gaps between components
      local function process_sections(sections)
        for name, section in pairs(sections) do
          -- left side sections are a/b/c; right side are x/y/z
          local left = name:sub(9, 10) < "x"

          -- Insert an Empty spacer between each real component
          -- (leave the very end of lualine_z alone so the closing separator renders nicely)
          for pos = 1, (name ~= "lualine_z" and #section or (#section - 1)) do
            table.insert(section, pos * 2, {
              Empty,
              -- Spacer colored the same on fg/bg so the slant looks like a "gap"
              color = { fg = colors.white, bg = colors.white },
            })
          end

          -- Apply slanted separators pointing inward
          for i, comp in ipairs(section) do
            if type(comp) ~= "table" then
              comp = { comp }
              section[i] = comp
            end
            comp.separator = left and { right = "" } or { left = "" }
          end
        end
        return sections
      end

      -- Helper components from the example
      local function search_result()
        if vim.v.hlsearch == 0 then
          return ""
        end
        local last_search = vim.fn.getreg("/")
        if not last_search or last_search == "" then
          return ""
        end
        local sc = vim.fn.searchcount({ maxcount = 9999 })
        return last_search .. "(" .. sc.current .. "/" .. sc.total .. ")"
      end

      local function modified()
        if vim.bo.modified then
          return "+"
        elseif vim.bo.modifiable == false or vim.bo.readonly == true then
          return "-"
        end
        return ""
      end

      require("lualine").setup({
        options = {
          theme = auto,
          component_separators = "",
          section_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = process_sections({
          lualine_a = { "mode" },
          lualine_b = {
            "branch",
            "diff",
            {
              "diagnostics",
              source = { "nvim" },
              sections = { "error" },
              diagnostics_color = { error = { bg = colors.red, fg = colors.white } },
            },
            {
              "diagnostics",
              source = { "nvim" },
              sections = { "warn" },
              diagnostics_color = { warn = { bg = colors.orange, fg = colors.white } },
            },
            { "filename", file_status = false, path = 1 },
            { modified, color = { bg = colors.red } },
            { "%w", cond = function() return vim.wo.previewwindow end },
            { "%r", cond = function() return vim.bo.readonly end },
            { "%q", cond = function() return vim.bo.buftype == "quickfix" end },
          },
          lualine_c = {},
          lualine_x = {},
          lualine_y = { search_result, "encoding", "fileformat", "filetype" },
          lualine_z = { "location", "progress" },
        }),
        inactive_sections = {
          lualine_c = { "%f %y %m" },
          lualine_x = {},
        },
      })

      -- ==== end: slanted-gaps example ====
    end,
  },
  {
    'mhinz/vim-signify'
  }
}

