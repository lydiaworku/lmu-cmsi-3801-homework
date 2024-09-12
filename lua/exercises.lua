function change(amount)
  if math.type(amount) ~= "integer" then
    error("Amount must be an integer")
  end
  if amount < 0 then
    error("Amount cannot be negative")
  end
  local counts, remaining = {}, amount
  for _, denomination in ipairs({25, 10, 5, 1}) do
    counts[denomination] = remaining // denomination
    remaining = remaining % denomination
  end
  return counts
end

-- Write your first then lower case function here
function first_then_lower_case(a, p)
  for _, letter in ipairs(a) do -- for loop to go through each letter in the a string
    if p(letter) then
      return string.lower(letter)
    end -- ending conditional
  end -- ending for loop
  return nil -- returning nil if p(letter) is false
end -- ending function

-- Write your powers generator here

function powers_generator(base, limit)
  local the_coroutine = coroutine.create(function()
    local power = 0
    local result = 0
    while result < limit do
      result = base ^ power
      power = power + 1
      if result <= limit then
        coroutine.yield(result)
      end -- ending if statement
    end -- ending while statement
  end) -- ending the return statement
  return the_coroutine
end -- ending the function
  
  
-- Write your say function here
function say(word)
  if word == nil then
    return ""
  else
    return function(next_word)
      if next_word ~= nil then
        return say(word .. " " .. next_word)
      else
        return word
      end -- ending the conditional
    end -- ending the return statement
  end -- ending the function
end

-- Write your line count function here
function meaningful_line_count(filename)
  local file, err = io.open(filename, "r") -- opening the file in reading mode
  if not file then
    error("No such file " .. filename)
  end -- throwing errors if the file is not found

  local count = 0

  for line in file:lines() do -- going through each line in the file
    local stripped_line = line:match("^%s*(.-)%s*$") -- getting rid of the whitespace
    if stripped_line ~= "" and not stripped_line:find("^%s*#") then
      count = count + 1
    end
  end

  file:close()
  return count

end


-- Write your Quaternion table here
Quaternion = {}
Quaternion.__index = Quaternion

function Quaternion.new(a, b, c, d)
  return setmetatable({a = a, b = b, c = c, d = d}, Quaternion)
end

function Quaternion:coefficients()
  return {self.a, self.b, self.c, self.d}
end

function Quaternion:conjugate()
  return Quaternion.new(self.a, -self.b, -self.c, -self.d)
end

function Quaternion.__add(original, other)
  return Quaternion.new(original.a + other.a, original.b + other.b, original.c + other.c, original.d + other.d)
end

function Quaternion.__eq(original, other)
  return original.a == other.a and original.b == other.b and original.c == other.c and original.d == other.d
end

function Quaternion.__mul(original, other)
  mult_a = (original.a * other.a) - (original.b * other.b) - (original.c * other.c) - (original.d * other.d)
  mult_b = (original.a * other.b) + (original.b * other.a) + (original.c * other.d) - (original.d * other.c)
  mult_c = (original.a * other.c) - (original.b * other.d) + (original.c * other.a) + (original.d * other.b)
  mult_d = (original.a * other.d) + (original.b * other.c) - (original.c * other.b) + (original.d * other.a)
  return Quaternion.new(mult_a, mult_b, mult_c, mult_d)
end

function Quaternion.__tostring(self)
  setofvalues = {{self.b, "i"}, {self.c, "j"}, {self.d, "k"}}
  total = ""

  if self.a == 0 and self.b == 0 and self.c == 0 and self.d == 0 then
    return "0"
  end

  if self.a ~= 0 then
    total = total .. string.format("%s", self.a)
  end

  for _, pair in pairs(setofvalues) do
    val, letter = pair[1], pair[2]
    if val > 0 and val ~= 1 then
      if total == "" then
        total = total .. string.format("%s", val)
        total = total .. string.format("%s", letter)
      else
        total = total .. "+" .. string.format("%s", val)
        total = total .. string.format("%s", letter)
      end

    elseif val < 0 and val ~= -1 then
      total = total .. string.format("%s", val)
      total = total .. string.format("%s", letter)
    
    elseif val == 1 then
      if total == "" then
        total = total .. string.format("%s", letter)
      else
        total = total .. "+" .. string.format("%s", letter)
      end

    elseif val == -1 then
      total = total .. "-" .. string.format("%s", letter)
    end
  end

  return total

end


