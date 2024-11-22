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
    end 
  end 
  return nil -- returning nil if p(letter) is false
end


-- Write your powers generator here

function powers_generator(base, limit)
  the_coroutine = coroutine.create(function()
    local power = 0 
    local result = 0 -- variables to represent exponent and result of calculations
    while result < limit do -- while result is less than limit, calculations are done
      result = base ^ power
      power = power + 1
      if result <= limit then
        coroutine.yield(result) -- result is yielded as long as the result is still less than or equal to limit
      end
    end
  end)
  return the_coroutine -- returning the_coroutine function
end

  
-- Write your say function here

function say(word)
  if word == nil then
    return "" -- returns the empty string if the word is nil
  else
    return function(next_word) -- another function is created for the next word
      if next_word ~= nil then
        return say(word .. " " .. next_word) -- recursively calls the say function
      else
        return word -- word is returned if next_word is nil
      end 
    end
  end
end

-- Write your line count function here

function meaningful_line_count(filename)
  file = io.open(filename, "r") -- opening the file in reading mode
  if not file then
    error("No such file " .. filename)
  end -- throwing errors if the file is not found

  count = 0

  for line in file:lines() do -- going through each line in the file
    strippedline = line:match("^%s*(.-)%s*$") -- getting rid of the whitespace
    if strippedline ~= "" and not strippedline:find("^%s*#") then
      count = count + 1
    end
  end
  file:close()
  return count
end


-- Write your Quaternion table here

Quaternion = {}
Quaternion.__index = Quaternion

-- making metatable for Quaternion table
function Quaternion.new(a, b, c, d)
  return setmetatable({a = a, b = b, c = c, d = d}, Quaternion)
end

-- returns the coefficients for a Quaternion
function Quaternion:coefficients()
  return {self.a, self.b, self.c, self.d}
end

-- returns the conjugate for a Quaternion
function Quaternion:conjugate()
  return Quaternion.new(self.a, -self.b, -self.c, -self.d)
end

-- overrides the addition method to add individual coeffients
function Quaternion.__add(original, other)
  return Quaternion.new(original.a + other.a, original.b + other.b, original.c + other.c, original.d + other.d)
end

-- overrides equality method to compare individual coefficients
function Quaternion.__eq(original, other)
  return original.a == other.a and original.b == other.b and original.c == other.c and original.d == other.d
end

-- overrides multiplication method to accurately multiply Quaternions
function Quaternion.__mul(original, other)
  mult_a = (original.a * other.a) - (original.b * other.b) - (original.c * other.c) - (original.d * other.d)
  mult_b = (original.a * other.b) + (original.b * other.a) + (original.c * other.d) - (original.d * other.c)
  mult_c = (original.a * other.c) - (original.b * other.d) + (original.c * other.a) + (original.d * other.b)
  mult_d = (original.a * other.d) + (original.b * other.c) - (original.c * other.b) + (original.d * other.a)
  return Quaternion.new(mult_a, mult_b, mult_c, mult_d)
end

-- overrides tostring method to turn a Quaternion into a string of operations
function Quaternion.__tostring(self)
  setofvalues = {{self.b, "i"}, {self.c, "j"}, {self.d, "k"}}
  total = ""

  -- handles the case of a Quaternion with all 0 coefficients
  if self.a == 0 and self.b == 0 and self.c == 0 and self.d == 0 then
    return "0"
  end

  -- handles the real number in the expression
  if self.a ~= 0 then
    total = total .. string.format("%s", self.a)
  end

  -- loop that handles the imaginary numbers in the expression
  for _, pair in pairs(setofvalues) do
    val, letter = pair[1], pair[2]

    -- positive coefficient that is not 1
    if val > 0 and val ~= 1 then
      if total == "" then
        total = total .. string.format("%s", val)
        total = total .. string.format("%s", letter)
      else
        total = total .. "+" .. string.format("%s", val)
        total = total .. string.format("%s", letter)
      end

    -- negative coefficient that is not -1
    elseif val < 0 and val ~= -1 then
      total = total .. string.format("%s", val)
      total = total .. string.format("%s", letter)

    -- coefficient of 1
    elseif val == 1 then
      if total == "" then
        total = total .. string.format("%s", letter)
      else
        total = total .. "+" .. string.format("%s", letter)
      end

    -- coefficient of -1
    elseif val == -1 then
      total = total .. "-" .. string.format("%s", letter)
    end
  end

  return total

end


