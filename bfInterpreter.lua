
braces = setmetatable({},{
    __index = function(self,k)
        if k == 'pop' then
            return function ()
                local item = self[#self]
                table.remove(self,#self)
                return item
            end
        end
    end
})

-- put ur bf(brainfuck) code into that test.bf file.

file = io.open('test.bf')
input = file:read()
file:close()

-- get rid of any text and \n aka line break
input = input:gsub('[%s\n%w]+','');

stack = {}
pointer = 0
memory_size = 100
out = ''
char = string.char
str_pointer = 0


for i = 0,memory_size-1 do
    stack[i]=0
end

-- instructions
Instructions = {
    ['>'] = function()
        pointer = pointer + 1
    end,
    ['<'] = function()
        pointer = pointer - 1
    end,
    ['.'] = function()
        out = out .. char(stack[pointer] or 0)
    end,
    ['+'] = function()
        stack[pointer] = (stack[pointer] or 0) + 1 
    end,
    ['-'] = function()
        stack[pointer] = ((stack[pointer] or 0) > 0 and (stack[pointer] or 0) - 1) or 0
    end,
    ['['] = function()
        if (stack[pointer] == 0) then
            while (input:sub(str_pointer,str_pointer) ~= ']' and str_pointer <= #input) do
                str_pointer = str_pointer + 1
            end
        else
            braces[#braces+1] = str_pointer
        end
    end,
    [']'] = function()
        if #braces > 0 then
            str_pointer = braces.pop()
            str_pointer = str_pointer - 1
        else
            str_pointer = str_pointer + 1
        end
    end
    -- [','] = function()
        
    -- end
}

-- lexeeer right here
while str_pointer < #input do
    str_pointer = str_pointer + 1
    local str = input:sub(str_pointer,str_pointer)

    assert(Instructions[str], 'Invalid Instruction: ' .. str)

    Instructions[str]()
end
print(out)
