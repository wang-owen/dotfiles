-- Contest workflow. The Competitive Companion browser extension sends a problem's
-- samples to Neovim; CompetiTest creates the source file from the template and
-- runs it against them.

local root = vim.fn.expand '~/Developer/cp'

-- Debug build: sanitizers, checked STL, and dbg() from root/dbg.h switched on
local cxx_flags = vim.split(
  '-std=gnu++23 -Wall -Wextra -Wshadow -g -Og -DLOCAL'
    .. ' -D_GLIBCXX_DEBUG -D_LIBCPP_HARDENING_MODE=_LIBCPP_HARDENING_MODE_DEBUG'
    .. ' -fsanitize=address,undefined -fno-sanitize-recover=all',
  ' '
)
table.insert(cxx_flags, '-I' .. root)
-- macOS gives the main thread 8 MB of stack; judges allow far more for deep recursion
if vim.fn.has 'mac' == 1 then table.insert(cxx_flags, '-Wl,-stack_size,0x10000000') end

-- Where a received problem goes under root: its directory and its file name without extension.
--   Codeforces  codeforces/2200, cf2200A   (2200 is the contest id in the URL, not the round number)
--   AtCoder     atcoder/abc430, abc430_a
--   elsewhere   <group>, <problem>, all in lower-case-with-dashes
local function locate(task)
  local url = task.url

  local contest, index = url:match 'codeforces%.com/.-/(%d+)/problem/(%w+)'
  if not contest then
    contest, index = url:match 'codeforces%.com/problemset/problem/(%d+)/(%w+)'
  end
  if contest then return root .. '/codeforces/' .. contest, 'cf' .. contest .. index end

  local id, problem = url:match 'atcoder%.jp/contests/([%w_-]+)/tasks/([%w_-]+)'
  if id then return root .. '/atcoder/' .. id, problem end

  local function slug(s) return (s:lower():gsub('[^%w]+', '-'):gsub('^%-', ''):gsub('%-$', '')) end
  return root .. '/' .. slug(task.group), slug(task.name)
end

-- Wait for a problem or contest from the browser and create its files in the given language.
-- `CompetiTest receive` takes no extension argument, so set it through setup(), which merges.
local function receive(what, ext)
  return function()
    require('competitest').setup { received_files_extension = ext }
    vim.cmd('CompetiTest receive ' .. what)
  end
end

return {
  'xeluxee/competitest.nvim',
  dependencies = { 'MunifTanjim/nui.nvim' },
  cmd = 'CompetiTest',
  keys = {
    { '<leader>cc', receive('contest', 'cc'), desc = '[C]ontest: receive whole [C]ontest (C++)' },
    { '<leader>cp', receive('problem', 'cc'), desc = '[C]ontest: receive one [P]roblem (C++)' },
    { '<leader>cC', receive('contest', 'py'), desc = '[C]ontest: receive whole [C]ontest (Python)' },
    { '<leader>cP', receive('problem', 'py'), desc = '[C]ontest: receive one [P]roblem (Python)' },
    { '<leader>cr', '<cmd>CompetiTest run<cr>', desc = '[C]ontest: build and [R]un samples' },
    { '<leader>ca', '<cmd>CompetiTest add_testcase<cr>', desc = '[C]ontest: [A]dd testcase' },
    { '<leader>ce', '<cmd>CompetiTest edit_testcase<cr>', desc = '[C]ontest: [E]dit testcase' },
  },
  opts = {
    compile_command = {
      cpp = { exec = 'c++', args = vim.list_extend(cxx_flags, { '$(FNAME)', '-o', '$(FNOEXT)' }) },
    },
    run_command = {
      -- MallocNanoZone=0 stops macOS malloc warning on every sanitizer run
      cpp = { exec = 'env', args = { 'MallocNanoZone=0', './$(FNOEXT)' } },
      -- PyPy as on the judge (Homebrew names it pypy3.11); LOCAL switches on dbg() in template.py
      python = { exec = 'env', args = { 'LOCAL=1', vim.fn.has 'mac' == 1 and 'pypy3.11' or 'pypy3', '$(FNAME)' } },
    },
    testcases_directory = 'tests',
    view_output_diff = true,

    template_file = { cc = root .. '/template.cc', py = root .. '/template.py' },
    received_problems_path = function(task, ext)
      local dir, name = locate(task)
      return dir .. '/' .. name .. '.' .. ext
    end,
    received_contests_directory = locate,
    received_contests_problems_path = function(task, ext)
      local _, name = locate(task)
      return name .. '.' .. ext
    end,
    -- The paths above are decided, so do not stop to ask during a contest
    received_problems_prompt_path = false,
    received_contests_prompt_directory = false,
    received_contests_prompt_extension = false,
  },
}
