return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    local opts = { noremap = true, silent = true }
    local on_attach = function(_, bufnr)
      opts.buffer = bufnr

      -- set keybinds
      opts.desc = "Show LSP references"
      keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

      opts.desc = "Go to declaration"
      keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

      opts.desc = "Show LSP definitions"
      keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

      opts.desc = "Show LSP implementations"
      keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

      opts.desc = "Show LSP type definitions"
      keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

      opts.desc = "See available code actions"
      keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

      opts.desc = "Smart rename"
      keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

      opts.desc = "Show buffer diagnostics"
      keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

      opts.desc = "Show line diagnostics"
      keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

      opts.desc = "Go to previous diagnostic"
      keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

      opts.desc = "Go to next diagnostic"
      keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

      opts.desc = "Show documentation for what is under cursor"
      keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

      opts.desc = "Restart LSP"
      keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

      -- TSTools commands
      -- opts.desc = "TS Organize Imports"
      -- keymap.set("n", "<leader>to", ":TSToolsOrganizeImports<CR>", opts)
      --
      -- opts.desc = "TS Auto Import"
      -- keymap.set("n", "<leader>ti", ":TSToolsAddMissingImports<CR>", opts)
      --
      -- opts.desc = "Go to source definition"
      -- keymap.set("n", "<leader>td", ":TSToolsGoToSourceDefinition<CR>", opts)
      --
      -- opts.desc = "TS rename file"
      -- keymap.set("n", "<leader>tr", ":TSToolsRenameFile<CR>", opts)
      --
      -- opts.desc = "TS file references"
      -- keymap.set("n", "<leader>tf", ":TSToolsFileReferences<CR>", opts)
      --
      -- opts.desc = "TS fix"
      -- keymap.set("n", "<leader>tx", ":TSToolsFixAll<CR>", opts)
    end

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- require("typescript-tools").setup({
    --   capabilities = capabilities,
    --   on_attach = on_attach,
    --   settings = {
    --     tsserver_file_preferences = {
    --       includeInlayParameterNameHints = "all",
    --       includeCompletionsForModuleExports = true,
    --       quotePreference = "auto",
    --     },
    --     tsserver_format_options = {
    --       allowIncompleteCompletions = false,
    --       allowRenameOfImportPath = true,
    --     },
    --   },
    -- })

    -- configure html server
    lspconfig["html"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure css server
    lspconfig["cssls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        css = { validate = true, lint = {
          unknownAtRules = "ignore",
        } },
      },
    })

    -- configure tailwindcss server
    lspconfig["tailwindcss"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        tailwindCSS = {
          experimental = {
            classRegex = {
              { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
              { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
            },
          },
        },
      },
    })

    -- configure prisma orm server
    lspconfig["prismals"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure emmet language server
    lspconfig["emmet_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = {
        "html",
        "typescriptreact",
        "javascriptreact",
        "css",
        "sass",
        "scss",
        "less",
        "svelte",
        "rescript",
        "heex",
        "elixir",
      },
      settings = {
        emmet = {
          includeLanguages = {
            phoenix_heex = "html",
            elixir = "html",
          },
        },
      },
    })

    -- lspconfig["pyright"].setup({
    --   capabilities = capabilities,
    --   on_attach = on_attach,
    --   settings = {
    --     python = {
    --       analysis = {
    --         typeCheckingMode = "strict",
    --       },
    --     },
    --   },
    -- })

    -- configure python server
    -- lspconfig["pylsp"].setup({
    --   capabilities = capabilities,
    --   on_attach = on_attach,
    --   settings = {
    --     pylsp = {
    --       plugins = {
    --         isort = { enabled = true },
    --         rope_autoimport = { enabled = true },
    --         pycodestyle = {
    --           maxLineLength = 88,
    --         },
    --       },
    --     },
    --   },
    -- })

    -- configure lua server (with special settings)
    lspconfig["lua_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = { -- custom settings for lua
        Lua = {
          -- make the language server recognize "vim" global
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            -- make language server aware of runtime files
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })

    -- configure c server
    lspconfig["clangd"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      cmd = {
        "clangd",
        "--offset-encoding=utf-16",
      },
    })
    vim.keymap.set("n", "<leader>i", ":ClangdSwitchSourceHeader<CR>")

    lspconfig["texlab"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["yamlls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["taplo"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["dockerls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["docker_compose_language_service"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- lspconfig["elixirls"].setup({
    --   -- cmd = { "/Users/charley/.local/share/nvim/mason/packages/elixir-ls/language_server.sh" },
    --   cmd = { "elixir-ls" },
    --   capabilities = capabilities,
    --   on_attach = on_attach,
    --   settings = {
    --     elixirLS = {
    --       autoBuild = true,
    --       dialyzerEnabled = true,
    --       suggestSpecs = true,
    --     },
    --   },
    -- })

    -- lspconfig["lexical"].setup({
    --   cmd = { "lexical" },
    --   capabilities = capabilities,
    --   on_attach = on_attach,
    -- })

    lspconfig["nextls"].setup({
      cmd = { "nextls", "--stdio" },
      capabilities = capabilities,
      on_attach = on_attach,
      init_options = {
        experimental = {
          completions = { enable = true },
        },
      },
    })

    lspconfig["jsonls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    require("lspconfig.configs").vtsls = require("vtsls").lspconfig
    lspconfig["vtsls"].setup({
      capabilities = capabilities,
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      on_attach = on_attach,
      settings = {
        vtsls = {
          autoUseWorkspaceTsdk = true,
          typescript = {
            format = {
              indentSize = 2,
            },
          },
        },
        typescript = {
          tsserver = {
            -- pluginPaths = { "./node_modules" },
            -- log = "verbose",
          },
        },
      },
    })

    lspconfig["gopls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    local function exepath(expr)
      local ep = vim.fn.exepath(expr)
      return ep ~= "" and ep or nil
    end

    local function get_python_path(workspace)
      local util = require("lspconfig.util")
      local path = util.path
      -- 1. Use activated virtualenv.
      if vim.env.VIRTUAL_ENV then
        return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
      end

      -- 2. Find and use virtualenv in workspace directory.
      for _, pattern in ipairs({ "*", ".*" }) do
        local match = vim.fn.glob(path.join(workspace, pattern, "pyvenv.cfg"))
        if vim.fn.empty(match) ~= 1 then
          return path.join(path.dirname(match), "bin", "python")
        end
      end

      -- 3. Find and use virtualenv managed by Poetry.
      if exepath("poetry") and path.is_file(path.join(workspace, "poetry.lock")) then
        local output = vim.fn.trim(vim.fn.system("poetry env info -p"))
        if path.is_dir(output) then
          return path.join(output, "bin", "python")
        end
      end

      -- 4. Find and use virtualenv managed by Pipenv.
      if exepath("pipenv") and path.is_file(path.join(workspace, "Pipfile")) then
        local output = vim.fn.trim(vim.fn.system("cd " .. workspace .. "; pipenv --py"))
        if path.is_dir(output) then
          return output
        end
      end

      -- 5. Fallback to system Python.
      return exepath("python3") or exepath("python") or "python"
    end

    local configs = require("lspconfig.configs")

    -- Check if the config is already defined (useful when reloading this file)
    if not configs.delance then
      configs.delance = {
        default_config = {
          before_init = function(_, config)
            if not config.settings.python then
              config.settings.python = {}
            end
            if not config.settings.python.pythonPath then
              config.settings.python.pythonPath = get_python_path(config.root_dir)
            end
          end,
          cmd = { "delance-langserver", "--stdio" },
          filetypes = { "python" },
          single_file_support = true,
          root_dir = function(fname)
            return lspconfig.util.find_git_ancestor(fname)
          end,
          settings = {
            python = {
              analysis = {
                -- extraPaths = { vim.fn.getcwd() },
                typeCheckingMode = "basic",
                diagnosticSeverityOverrides = {},
                diagnosticMode = "openFilesOnly",
                stubPath = "./typings",
                autoImportCompletions = true,
                autoSearchPaths = true,
                watchForLibraryChanges = true,
                functionReturnInlayTypeHints = false,
                useLibraryCodeForType = true,
                variableInlayHints = true,
                inlayHints = {
                  variableTypes = true,
                  functionReturnTypes = true,
                  callArgumentNames = false,
                  pytestParameters = true,
                },
              },
            },
          },
        },
      }
    end

    lspconfig["delance"].setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        if client.server_capabilities.inlayHintProvider then
          print("Inlay")
          vim.g.inlay_hints_visible = true
          vim.lsp.inlay_hint.enable(true)
        else
          print("no inlay hints available")
        end
      end,
    })

    -- lspconfig["graphql"].setup({
    --   capabilities = capabilities,
    --   on_attach = on_attach,
    --   filetypes = { "graphql", "typescriptreact", "javascriptreact", "typescript", "javascript" },
    -- })
    local log = require("vim.lsp.log")
    local util = require("lspconfig.util")
    if not configs.rescript_relay_lsp then
      configs.rescript_relay_lsp = {
        default_config = {
          auto_start_compiler = false,
          cmd = { "rescript-relay-compiler", "lsp" },
          root_dir = lspconfig.util.root_pattern("relay.config.*"),
          filetypes = { "rescript" },
          on_new_config = function(config, root_dir)
            local project_root = util.find_node_modules_ancestor(root_dir)
            local node_bin_path = util.path.join(project_root, "node_modules", ".bin")
            local compiler_cmd = { util.path.join(node_bin_path, "rescript-relay-compiler"), "--watch" }
            local path = node_bin_path .. util.path.path_separator .. vim.env.PATH
            if config.cmd_env then
              config.cmd_env.PATH = path
            else
              config.cmd_env = { PATH = path }
            end

            if config.path_to_config then
              config.path_to_config = util.path.sanitize(config.path_to_config)
              local path_to_config = util.path.join(root_dir, config.path_to_config)
              if util.path.exists(path_to_config) then
                vim.list_extend(config.cmd, { config.path_to_config })
                vim.list_extend(compiler_cmd, { config.path_to_config })
              else
                log.error("[Rescript Relay LSP] Can't find Relay config file. Fallback to the default location...")
              end
            end
            if config.auto_start_compiler then
              vim.fn.jobstart(compiler_cmd, {
                on_exit = function()
                  log.info("[Rescript Relay LSP] Rescript Relay Compiler exited")
                end,
                cwd = project_root,
              })
            end
          end,
          handlers = {
            ["window/showStatus"] = function(_, result)
              if not result then
                return {}
              end
              local log_message = string.format("[Rescript Relay LSP] %q", result.message)
              if result.type == 1 then
                log.error(log_message)
              end
              if result.type == 2 then
                log.warn(log_message)
              end
              if result.type == 3 then
                log.info(log_message)
              end
              return {}
            end,
          },
        },
      }
    end

    lspconfig.rescript_relay_lsp.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig.relay_lsp.setup({
      -- (default: false) Whether or not we should automatically start
      -- the Relay Compiler in watch mode when you open a project
      auto_start_compiler = false,
      cmd = { "relay-compiler", "lsp" },

      root_dir = lspconfig.util.root_pattern("relay.config.*"),
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },

      -- (default: null) Path to a relay config relative to the
      -- `root_dir`. Without this, the compiler will search for your
      -- config. This is helpful if your relay project is in a nested
      -- directory.
      -- path_to_config = "./platform/relay.config.json",
    })

    lspconfig.jdtls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig.rescriptls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      -- settings = {
      --   allowBuiltInFormatter = true,
      --   inlayHints = { enable = true },
      --   config = { allowBuiltInFormatter = true, inlayHints = { enable = true } },
      --   extensionConfiguration = { allowBuiltInFormatter = true, inlayHints = { enable = true } },
      -- },
    })

    lspconfig.eslint.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig.astro.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig.lemminx.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig.terraformls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end,
}
