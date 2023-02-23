local Job = require "plenary.job"
local dir = ".tests/docs"

describe("finders", function()
  before_each(function()
    Job:new({
      command = "mkdir",
      args = { "-p", dir },
    }):sync()
    Job:new({
      command = "touch",
      args = {
        "hello-world.md",
        "not-relevant",
      },
      cwd = dir,
    }):sync()
  end)

  after_each(function()
    Job:new({
      command = "rm",
      args = { "-rf", dir },
    }):sync()
  end)

  it("has correct doc sites", function()
    local Config = require "laravel-docs.config"

    Config.set {
      directory = dir,
    }

    local finders = require "laravel-docs.finders"

    local docs = finders.find_doc_sites()

    assert.equal(1, #docs)
    assert.equal("hello-world", docs[1].slug)
    assert.equal("Hello World", docs[1].name)
    assert.equal(dir .. "/hello-world.md", docs[1].path)
  end)

  -- it("has correct sub headings", function()
  --   os.execute [[echo '# Header\n\n<a name="test"></a>\n## test' > .tests/docs/hello-world.md]]

  --   local Config = require "laravel-docs.config"

  --   Config.set {
  --     directory = dir,
  --   }

  --   local finders = require "laravel-docs.finders"

  --   local headings = finders.find_sub_headings "hello-world"

  --   vim.pretty_print(headings)
  -- end)
end)
