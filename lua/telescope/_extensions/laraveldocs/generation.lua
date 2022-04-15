local function mysplit (inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

local M = {}

M.generate = function (version)
  local dictionary = {}
  local repository = 'https://github.com/laravel/docs.git'

  if version == nil then
    os.execute('git clone -q ' .. repository .. ' /tmp/laraveldocs')
  else
    os.execute('git clone -q -b ' .. version .. ' ' .. repository .. ' /tmp/laraveldocs')
  end

  os.execute('ls /tmp/laraveldocs > /tmp/laraveldocs.txt')
  os.execute('rm -rf /tmp/laraveldocs')

  local file = io.open('/tmp/laraveldocs.txt',"r")
  local read = file:read("*all")
  file:close()
  os.remove('/tmp/laraveldocs.txt')

  local from = 1
  local delim_from, delim_to = string.find( read, "\n", from  )
  while delim_from do
    local slug = string.sub(read, from, delim_from-4)

    local splits = mysplit(slug, '-')

    for i,split in splits do
      splits[i] = firstToUpper(split)
    end

    local entry = {
      slug = slug,
      name = table.concat(splits, ' '),
    }

    table.insert(dictionary, entry)
    from  = delim_to + 1
    delim_from, delim_to = string.find(read, "\n", from)
  end

  return dictionary
end

return M
