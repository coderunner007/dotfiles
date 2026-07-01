return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Diagnostics UI
      vim.diagnostic.config({
        virtual_text = true,
        severity_sort = true,
        float = { border = "rounded", source = "always" },
      })
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
          },
        },
      })

      local servers = {
        -- Lua
        lua_ls = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },

        -- Go
        gopls = {
          usePlaceholders = true,
          gofumpt = true,
          -- completeUnimported = true,
          staticcheck = true,
          analyses = { unusedparams = true, nilness = true, unusedwrite = true, shadow = true, unreachable = true },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            constantValues = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },

        -- Deno: only attach in real Deno projects (deno.json present)
        denols = {
          root_markers = { "deno.json", "deno.jsonc" },
          enable = true,
          suggest = {
            imports = {
              hosts = {
                ["https://deno.land"] = true
              }
            }
          }
        },

        -- TypeScript / JS: node projects (package.json), not Deno
        ts_ls = {
          root_markers = { "package.json", "tsconfig.json" },
          single_file_support = false,
        },

        -- ESLint: reads the repo's .eslintrc.* (this surfaces repo lint rules)
        eslint = {
          root_markers = {
            ".eslintrc", ".eslintrc.js", ".eslintrc.cjs",
            ".eslintrc.json", ".eslintrc.yaml", ".eslintrc.yml",
            "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs"
          },
        },

        -- Extras (optional)
        pyright = {},
        bashls = {},
        jsonls = {},
        yamlls = {},
      }
      -- Auto-completion
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
          end
        end,
      })
      vim.cmd("set completeopt+=noselect")

      -- Keymaps on attach (pure LSP, no Telescope)
      local function on_attach(client, buf)
        vim.o.winborder = "rounded"

        -- Show relevant lsp output in fzf window
        local function on_list(opts)
          -- write results to the current window's loclist
          vim.fn.setloclist(0, {}, ' ', opts)
          -- open fzf-lua’s loclist picker
          vim.schedule(function()
            local ok, fzf = pcall(require, 'fzf-lua')
            if ok then fzf.loclist() else vim.cmd('lopen') end
          end)
        end

        vim.keymap.set("n", "grr", function() vim.lsp.buf.references(nil, { on_list = on_list }) end)
        vim.keymap.set("n", "gri", function() vim.lsp.buf.implementation({ on_list = on_list }) end)
        vim.keymap.set("n", "gO", function() vim.lsp.buf.document_symbol({ on_list = on_list }) end)

        -- Document highlights
        if client.server_capabilities.documentHighlightProvider then
          local grp = vim.api.nvim_create_augroup("LspDocHL_" .. buf, { clear = true })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = grp, buffer = buf, callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd("CursorMoved", {
            group = grp, buffer = buf, callback = vim.lsp.buf.clear_references,
          })
        end

        -- -- Codelens
        if client.server_capabilities.codeLensProvider then
          local grp = vim.api.nvim_create_augroup("LspCodeLens_" .. buf, { clear = true })
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            group = grp, buffer = buf,
            callback = function() vim.lsp.codelens.refresh({ bufnr = buf }) end,
          })
          vim.lsp.codelens.refresh({ bufnr = buf })
        end
      end

      -- Base capabilities (no cmp)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

      -- Servers (tweak as you like)

      -- Wire up servers
      -- For every LSP server, add the relevant configration as mentioned above
      local function xetup(name, cfg)
        cfg = cfg or {}
        cfg.on_attach = on_attach
        -- cfg.capabilities = vim.tbl_deep_extend("force", {}, capabilities, cfg.capabilities or {})
        vim.lsp.config(name, cfg) -- merges onto bundled lsp/<name>.lua defaults
      end

      for name, cfg in pairs(servers) do
        xetup(name, cfg)
      end

      vim.lsp.enable(vim.tbl_keys(servers)) -- arms FileType-based auto-attach

      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
          local clients = vim.lsp.get_active_clients({ bufnr = 0 })
          if #clients == 0 then
            return
          end

          for _, client in ipairs(clients) do
            -- Go: organize imports before formatting
            if client.name == "gopls" then
              local params = vim.lsp.util.make_range_params()
              params.context = { only = { "source.organizeImports" } }
              local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
              for cid, res in pairs(result or {}) do
                for _, r in pairs(res.result or {}) do
                  if r.edit then
                    local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                    vim.lsp.util.apply_workspace_edit(r.edit, enc)
                  end
                end
              end
            end
          end

          -- General formatting (sync so it happens before save completes)
          vim.lsp.buf.format({ async = false })
        end,
      })


      -------------------------------------------------------------------------
    end,
  },
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    config = true,
  },
}
