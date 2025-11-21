---@class snacks.Picker
---@field [string] unknown
---@class snacks.picker.Config
---@field [string] unknown

local function set_globs()
  vim.ui.input({ prompt = 'Grep Filter Globs> ', default = vim.g.Session_rg_glob or "" }, function (input)
    if input ~= nil then
      vim.g.Session_rg_glob = input
    end
  end)
end

local function get_globs()
  local globs = {}
  for substring in (vim.g.Session_rg_glob or ""):gmatch("%S+") do
    table.insert(globs, substring)
  end
  return globs
end

local list_extend = function(where, what)
  return vim.list_extend(vim.deepcopy(where), what)
end

local list_filter = function(where, what)
  -- stylua: ignore
  return vim.iter(where):filter(function(val) return not vim.list_contains(what, val) end):totable()
end

return {
  "folke/snacks.nvim",

  opts = function ()
    local persistence = require("persistence")
    local persistence_config = require("persistence.config")
    local uv = vim.uv or vim.loop

    local items = {}
    local have = {}
    for _, session in ipairs(persistence.list()) do
      if uv.fs_stat(session) then
        local file = session:sub(#persistence_config.options.dir + 1, -5)
        local dir, _ = unpack(vim.split(file, "%%", { plain = true }))
        dir = dir:gsub("%%", "/")
        if jit.os:find("Windows") then
          dir = dir:gsub("^(%w)/", "%1:/")
        end
        if not have[dir] then
          have[dir] = true
          items[#items + 1] = dir
        end
      end
    end

    return {
      picker = {
        show_delay = 1000,
        sources = {
          grep = {
            case_sens = true,
            toggles = {
              case_sens = 's',
            },
            finder = function(opts, ctx)
              local args_extend = { '--ignore-case' }
              opts.args = list_filter(opts.args or {}, args_extend)
              if not opts.case_sens then
                opts.args = list_extend(opts.args, args_extend)
              end
              return require('snacks.picker.source.grep').grep(opts, ctx)
            end,
            actions = {
              toggle_live_case_sens = function(picker)
                picker.opts.case_sens = not picker.opts.case_sens
                picker:find()
              end,
            },
            win = {
              input = {
                keys = {
                  ['<M-s>'] = { 'toggle_live_case_sens', mode = { 'i', 'n' } },
                },
              },
            },
          },
        },
      },
      notifier = {},
      explorer = {},
      dashboard = {
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 2 },
          { title = "Sessions", padding = 1 },
          { section = "projects", dirs = items, padding = 1 },
          { section = "startup" },
        },
      },
    }
  end,

  lazy = false,

  keys = {
    -- Top Pickers & Explorer
    { "<leader><leader>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>n", function() Snacks.picker.noice() end, desc = "Notification History" },
    { "<leader>mn", function() Snacks.notifier.hide() end, desc = "Hide Notifications" },
    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
    -- Top Grep
    { "<leader>/", function() Snacks.picker.grep({ glob = get_globs() }) end, desc = "Grep" },
    { "<leader>mm", set_globs, desc = "Set Grep Globs" },
    { "<leader>m/", function() Snacks.picker.grep_word({ glob = get_globs() }) end, desc = "Grep for Visual Selection or Word", mode = { "n", "x" } },
    -- find
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    { "<leader>fs", function() Snacks.picker.files({ search = function () return vim.fn.expand("%:t:r"):gsub("^[^_]*_", "") end }) end, desc = "Related Files" },
    -- git
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    -- Grep
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep in Open Buffers" },
    { "<leader>sg", function() Snacks.picker.grep({ glob = get_globs() }) end, desc = "Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word({ glob = get_globs() }) end, desc = "Grep for Visual Selection or Word", mode = { "n", "x" } },
    -- search
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
  }
}
