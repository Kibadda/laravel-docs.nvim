local M = {}

M.generate = function (version)
  local dictionary = {'haha'}
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
    table.insert(dictionary, string.sub( read, from , delim_from-1 ) )
    from  = delim_to + 1
    delim_from, delim_to = string.find( read, "\n", from  )
  end

  return dictionary
end

return M
