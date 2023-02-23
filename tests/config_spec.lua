describe("config", function()
  it("has default values after set()", function()
    local Config = require "laravel-docs.config"

    Config.set()

    assert.equal("10.x", Config.options.version)
    assert.equal(vim.fn.stdpath "cache" .. "/laravel-docs", Config.options.directory)
    assert.equal(true, Config.options.preview)
    assert.equal(false, Config.options.glow)
    assert.equal(vim.fn.stdpath "state" .. "/laravel-docs.log", Config.options.log)
  end)

  it("has new values with custom config", function()
    local Config = require "laravel-docs.config"

    local options = {
      version = "master",
      directory = "~/other/git/directory",
      preview = false,
      glow = true,
      log = "~/other/log/location/name.log",
    }

    Config.set(options)

    assert.equal(options.version, Config.options.version)
    assert.equal(options.directory, Config.options.directory)
    assert.equal(options.preview, Config.options.preview)
    assert.equal(options.glow, Config.options.glow)
    assert.equal(options.log, Config.options.log)
  end)
end)
