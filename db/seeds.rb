# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Seeding database..."

# =============================================================================
# USERS
# =============================================================================

admin = User.find_or_create_by!(email: "admin@example.com") do |u|
  u.username = "admin"
  u.password = "password123"
  u.password_confirmation = "password123"
  u.admin = true
  u.level = 5
  u.total_points = 500
end
puts "  Created admin user: admin@example.com / password123"

user1 = User.find_or_create_by!(email: "user1@example.com") do |u|
  u.username = "user1"
  u.password = "password123"
  u.password_confirmation = "password123"
  u.level = 2
  u.total_points = 100
end
puts "  Created test user: user1@example.com / password123"

# =============================================================================
# MODULE 1: Ruby Basics
# =============================================================================

hello_lesson = Lesson.find_or_create_by!(module_number: 1, position: 1) do |l|
  l.title = "Hello World"
  l.title_ru = "Привет, мир"
  l.description = "Learn the basics of Ruby functions and return values. This is your first step into Ruby programming!"
  l.description_ru = "Изучите основы функций Ruby и возвращаемых значений. Это ваш первый шаг в программирование на Ruby!"
  l.difficulty = :beginner
  l.ruby_version = "3.4"
end

Exercise.find_or_create_by!(lesson: hello_lesson, position: 1) do |e|
  e.title = "Say Hello"
  e.title_ru = "Скажи привет"
  e.description = "Create your first Ruby function that returns a greeting."
  e.description_ru = "Создайте свою первую функцию Ruby, которая возвращает приветствие."
  e.instructions = <<~MD
    Create a function called `hello` that returns the string "Hello!".

    In Ruby, functions are defined using the `def` keyword. The last expression
    in a function is automatically returned.
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `hello`, которая возвращает строку "Hello!".

    В Ruby функции определяются с помощью ключевого слова `def`. Последнее выражение
    в функции автоматически возвращается.
  MD
  e.hints = [
    "Functions are defined with def...end",
    "Ruby automatically returns the last expression",
    "Strings are created with quotes: \"Hello!\""
  ]
  e.hints_ru = [
    "Функции определяются с помощью def...end",
    "Ruby автоматически возвращает последнее выражение",
    "Строки создаются с помощью кавычек: \"Hello!\""
  ]
  e.starter_code = <<~RUBY
    def hello
      # Your code here
    end
  RUBY
  e.solution_code = <<~RUBY
    def hello
      "Hello!"
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "hello function" do
      it "returns Hello!" do
        expect(hello).to eq("Hello!")
      end
    end
  RUBY
  e.topics = [ "functions", "strings", "return values" ]
  e.points = 10
end

Exercise.find_or_create_by!(lesson: hello_lesson, position: 2) do |e|
  e.title = "Greet Someone"
  e.title_ru = "Поприветствуй кого-то"
  e.description = "Create a function that accepts a name and returns a personalized greeting."
  e.description_ru = "Создайте функцию, которая принимает имя и возвращает персональное приветствие."
  e.instructions = <<~MD
    Create a function called `greet` that takes a `name` parameter and returns
    "Hello, {name}!" where {name} is replaced with the actual name.

    Use string interpolation with `\#{variable}` inside double quotes.
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `greet`, которая принимает параметр `name` и возвращает
    "Hello, {name}!", где {name} заменяется на фактическое имя.

    Используйте интерполяцию строк с `\#{variable}` внутри двойных кавычек.
  MD
  e.hints = [
    "Use string interpolation: \"Hello, \#{name}!\"",
    "Parameters go in parentheses after the function name",
    "Make sure to use double quotes for interpolation"
  ]
  e.hints_ru = [
    "Используйте интерполяцию строк: \"Hello, \#{name}!\"",
    "Параметры указываются в скобках после имени функции",
    "Для интерполяции используйте двойные кавычки"
  ]
  e.starter_code = <<~RUBY
    def greet(name)
      # Your code here
    end
  RUBY
  e.solution_code = <<~RUBY
    def greet(name)
      "Hello, \#{name}!"
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "greet function" do
      it "greets Alice" do
        expect(greet("Alice")).to eq("Hello, Alice!")
      end

      it "greets Bob" do
        expect(greet("Bob")).to eq("Hello, Bob!")
      end

      it "greets World" do
        expect(greet("World")).to eq("Hello, World!")
      end
    end
  RUBY
  e.topics = [ "functions", "arguments", "string interpolation" ]
  e.points = 15
end

Exercise.find_or_create_by!(lesson: hello_lesson, position: 3) do |e|
  e.title = "Default Greeting"
  e.title_ru = "Приветствие по умолчанию"
  e.description = "Create a function with a default parameter value."
  e.description_ru = "Создайте функцию с параметром по умолчанию."
  e.instructions = <<~MD
    Create a function called `greet_with_default` that takes an optional `name` parameter.

    - If a name is provided, return "Hello, {name}!"
    - If no name is provided, default to "World"

    Use default parameter syntax: `def method(param = default_value)`
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `greet_with_default`, которая принимает необязательный параметр `name`.

    - Если имя указано, верните "Hello, {name}!"
    - Если имя не указано, используйте по умолчанию "World"

    Используйте синтаксис параметра по умолчанию: `def method(param = default_value)`
  MD
  e.hints = [
    "Use def greet_with_default(name = \"World\")",
    "The default value is used when no argument is passed",
    "You can still use string interpolation"
  ]
  e.hints_ru = [
    "Используйте def greet_with_default(name = \"World\")",
    "Значение по умолчанию используется, когда аргумент не передан",
    "Вы всё ещё можете использовать интерполяцию строк"
  ]
  e.starter_code = <<~RUBY
    def greet_with_default(name)
      # Add a default value and return the greeting
    end
  RUBY
  e.solution_code = <<~RUBY
    def greet_with_default(name = "World")
      "Hello, \#{name}!"
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "greet_with_default" do
      it "greets with provided name" do
        expect(greet_with_default("Ruby")).to eq("Hello, Ruby!")
      end

      it "uses default when no name provided" do
        expect(greet_with_default).to eq("Hello, World!")
      end
    end
  RUBY
  e.topics = [ "functions", "default parameters", "string interpolation" ]
  e.points = 15
end

# Temperature Lesson
temp_lesson = Lesson.find_or_create_by!(module_number: 1, position: 2) do |l|
  l.title = "Temperature Converter"
  l.title_ru = "Конвертер температуры"
  l.description = "Learn about basic math operations by building temperature conversion functions."
  l.description_ru = "Изучите базовые математические операции, создавая функции конвертации температуры."
  l.difficulty = :beginner
  l.ruby_version = "3.4"
end

Exercise.find_or_create_by!(lesson: temp_lesson, position: 1) do |e|
  e.title = "Fahrenheit to Celsius"
  e.title_ru = "Из Фаренгейта в Цельсий"
  e.description = "Convert temperature from Fahrenheit to Celsius."
  e.description_ru = "Конвертируйте температуру из Фаренгейта в Цельсий."
  e.instructions = <<~MD
    Create a function `ftoc` that converts Fahrenheit to Celsius.

    The formula is: C = (F - 32) * 5/9

    Make sure to return a float value.
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `ftoc`, которая конвертирует Фаренгейт в Цельсий.

    Формула: C = (F - 32) * 5/9

    Убедитесь, что возвращаете число с плавающей точкой.
  MD
  e.hints = [
    "Use the formula: (fahrenheit - 32) * 5.0 / 9.0",
    "Use 5.0 instead of 5 to get float division",
    "Ruby will automatically return the last expression"
  ]
  e.hints_ru = [
    "Используйте формулу: (fahrenheit - 32) * 5.0 / 9.0",
    "Используйте 5.0 вместо 5 для деления с плавающей точкой",
    "Ruby автоматически возвращает последнее выражение"
  ]
  e.starter_code = <<~RUBY
    def ftoc(fahrenheit)
      # Your code here
    end
  RUBY
  e.solution_code = <<~RUBY
    def ftoc(fahrenheit)
      (fahrenheit - 32) * 5.0 / 9.0
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "ftoc" do
      it "converts freezing point" do
        expect(ftoc(32)).to eq(0)
      end

      it "converts boiling point" do
        expect(ftoc(212)).to eq(100)
      end

      it "converts body temperature" do
        expect(ftoc(98.6)).to be_within(0.1).of(37)
      end
    end
  RUBY
  e.topics = [ "functions", "math", "float" ]
  e.points = 15
end

Exercise.find_or_create_by!(lesson: temp_lesson, position: 2) do |e|
  e.title = "Celsius to Fahrenheit"
  e.title_ru = "Из Цельсия в Фаренгейт"
  e.description = "Convert temperature from Celsius to Fahrenheit."
  e.description_ru = "Конвертируйте температуру из Цельсия в Фаренгейт."
  e.instructions = <<~MD
    Create a function `ctof` that converts Celsius to Fahrenheit.

    The formula is: F = C * 9/5 + 32
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `ctof`, которая конвертирует Цельсий в Фаренгейт.

    Формула: F = C * 9/5 + 32
  MD
  e.hints = [
    "Use the formula: celsius * 9.0 / 5.0 + 32",
    "This is the inverse of the ftoc function"
  ]
  e.hints_ru = [
    "Используйте формулу: celsius * 9.0 / 5.0 + 32",
    "Это обратная функция для ftoc"
  ]
  e.starter_code = <<~RUBY
    def ctof(celsius)
      # Your code here
    end
  RUBY
  e.solution_code = <<~RUBY
    def ctof(celsius)
      celsius * 9.0 / 5.0 + 32
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "ctof" do
      it "converts freezing point" do
        expect(ctof(0)).to eq(32)
      end

      it "converts boiling point" do
        expect(ctof(100)).to eq(212)
      end

      it "converts body temperature" do
        expect(ctof(37)).to be_within(0.1).of(98.6)
      end
    end
  RUBY
  e.topics = [ "functions", "math", "float" ]
  e.points = 15
end

# Calculator Lesson
calc_lesson = Lesson.find_or_create_by!(module_number: 1, position: 3) do |l|
  l.title = "Calculator"
  l.title_ru = "Калькулятор"
  l.description = "Build a calculator with various operations. Learn about arrays and iteration."
  l.description_ru = "Создайте калькулятор с различными операциями. Изучите массивы и итерации."
  l.difficulty = :beginner
  l.ruby_version = "3.4"
end

Exercise.find_or_create_by!(lesson: calc_lesson, position: 1) do |e|
  e.title = "Add Two Numbers"
  e.title_ru = "Сложение двух чисел"
  e.description = "Create a simple addition function."
  e.description_ru = "Создайте простую функцию сложения."
  e.instructions = "Create a function `add` that takes two numbers and returns their sum."
  e.instructions_ru = "Создайте функцию `add`, которая принимает два числа и возвращает их сумму."
  e.hints = [ "Use the + operator" ]
  e.hints_ru = [ "Используйте оператор +" ]
  e.starter_code = "def add(a, b)\n  # Your code here\nend"
  e.solution_code = "def add(a, b)\n  a + b\nend"
  e.test_code = <<~RUBY
    RSpec.describe "add" do
      it "adds positive numbers" do
        expect(add(2, 3)).to eq(5)
      end

      it "adds negative numbers" do
        expect(add(-1, -2)).to eq(-3)
      end

      it "adds zero" do
        expect(add(5, 0)).to eq(5)
      end
    end
  RUBY
  e.topics = [ "functions", "math", "operators" ]
  e.points = 10
end

Exercise.find_or_create_by!(lesson: calc_lesson, position: 2) do |e|
  e.title = "Sum an Array"
  e.title_ru = "Сумма массива"
  e.description = "Sum all numbers in an array using Ruby's built-in methods."
  e.description_ru = "Суммируйте все числа в массиве, используя встроенные методы Ruby."
  e.instructions = <<~MD
    Create a function `sum` that takes an array of numbers and returns their sum.

    Hint: Ruby arrays have a `sum` method!
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `sum`, которая принимает массив чисел и возвращает их сумму.

    Подсказка: у массивов Ruby есть метод `sum`!
  MD
  e.hints = [
    "Try using the .sum method on arrays",
    "Or use .reduce(:+) for a more manual approach"
  ]
  e.hints_ru = [
    "Попробуйте использовать метод .sum для массивов",
    "Или используйте .reduce(:+) для более ручного подхода"
  ]
  e.starter_code = "def sum(numbers)\n  # Your code here\nend"
  e.solution_code = "def sum(numbers)\n  numbers.sum\nend"
  e.test_code = <<~RUBY
    RSpec.describe "sum" do
      it "sums an array of numbers" do
        expect(sum([1, 2, 3, 4])).to eq(10)
      end

      it "returns 0 for empty array" do
        expect(sum([])).to eq(0)
      end

      it "handles negative numbers" do
        expect(sum([-1, 1, -2, 2])).to eq(0)
      end
    end
  RUBY
  e.topics = [ "arrays", "iteration", "sum" ]
  e.points = 15
end

Exercise.find_or_create_by!(lesson: calc_lesson, position: 3) do |e|
  e.title = "Factorial"
  e.title_ru = "Факториал"
  e.description = "Calculate the factorial of a number."
  e.description_ru = "Вычислите факториал числа."
  e.instructions = <<~MD
    Create a function `factorial` that calculates n! (n factorial).

    factorial(0) = 1
    factorial(5) = 5 * 4 * 3 * 2 * 1 = 120

    You can use recursion or iteration.
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `factorial`, которая вычисляет n! (факториал n).

    factorial(0) = 1
    factorial(5) = 5 * 4 * 3 * 2 * 1 = 120

    Вы можете использовать рекурсию или итерацию.
  MD
  e.hints = [
    "Base case: factorial(0) = 1",
    "Try using (1..n).reduce(1, :*)",
    "Or use recursion: n * factorial(n-1)"
  ]
  e.hints_ru = [
    "Базовый случай: factorial(0) = 1",
    "Попробуйте использовать (1..n).reduce(1, :*)",
    "Или используйте рекурсию: n * factorial(n-1)"
  ]
  e.starter_code = "def factorial(n)\n  # Your code here\nend"
  e.solution_code = "def factorial(n)\n  return 1 if n <= 1\n  (1..n).reduce(1, :*)\nend"
  e.test_code = <<~RUBY
    RSpec.describe "factorial" do
      it "returns 1 for 0" do
        expect(factorial(0)).to eq(1)
      end

      it "returns 1 for 1" do
        expect(factorial(1)).to eq(1)
      end

      it "calculates factorial of 5" do
        expect(factorial(5)).to eq(120)
      end

      it "calculates factorial of 10" do
        expect(factorial(10)).to eq(3628800)
      end
    end
  RUBY
  e.topics = [ "recursion", "iteration", "math" ]
  e.points = 20
end

Exercise.find_or_create_by!(lesson: calc_lesson, position: 4) do |e|
  e.title = "Product with Reduce"
  e.title_ru = "Произведение с Reduce"
  e.description = "Use reduce to multiply all numbers in an array."
  e.description_ru = "Используйте reduce для умножения всех чисел в массиве."
  e.instructions = <<~MD
    Create a function `product` that takes an array of numbers and returns their product (multiplication).

    Use the `reduce` method (also known as `inject`).

    ```ruby
    product([1, 2, 3, 4])  # => 24 (1 * 2 * 3 * 4)
    product([5, 2])        # => 10
    ```

    `reduce` takes an initial value and a block that combines elements:
    ```ruby
    [1, 2, 3].reduce(0) { |acc, n| acc + n }  # => 6
    ```
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `product`, которая принимает массив чисел и возвращает их произведение.

    Используйте метод `reduce` (также известный как `inject`).

    ```ruby
    product([1, 2, 3, 4])  # => 24 (1 * 2 * 3 * 4)
    product([5, 2])        # => 10
    ```

    `reduce` принимает начальное значение и блок, который комбинирует элементы:
    ```ruby
    [1, 2, 3].reduce(0) { |acc, n| acc + n }  # => 6
    ```
  MD
  e.hints = [
    "Use .reduce(1) { |acc, n| acc * n }",
    "Start with 1 (identity for multiplication)",
    "Or use shorthand: .reduce(1, :*)"
  ]
  e.hints_ru = [
    "Используйте .reduce(1) { |acc, n| acc * n }",
    "Начните с 1 (единица для умножения)",
    "Или используйте сокращённую форму: .reduce(1, :*)"
  ]
  e.starter_code = "def product(numbers)\n  # Use reduce to multiply all numbers\nend"
  e.solution_code = "def product(numbers)\n  numbers.reduce(1) { |acc, n| acc * n }\nend"
  e.test_code = <<~RUBY
    RSpec.describe "product" do
      it "multiplies all numbers" do
        expect(product([1, 2, 3, 4])).to eq(24)
      end

      it "returns 1 for empty array" do
        expect(product([])).to eq(1)
      end

      it "handles single element" do
        expect(product([5])).to eq(5)
      end

      it "handles zeros" do
        expect(product([1, 2, 0, 4])).to eq(0)
      end

      it "handles negative numbers" do
        expect(product([-2, 3])).to eq(-6)
      end
    end
  RUBY
  e.topics = [ "reduce", "inject", "accumulation", "functional" ]
  e.points = 20
end

# Conditionals Lesson
cond_lesson = Lesson.find_or_create_by!(module_number: 1, position: 4) do |l|
  l.title = "Conditionals"
  l.title_ru = "Условные операторы"
  l.description = "Learn how to make decisions in your code using if, else, and case statements."
  l.description_ru = "Научитесь принимать решения в коде с помощью if, else и case."
  l.difficulty = :beginner
  l.ruby_version = "3.4"
end

Exercise.find_or_create_by!(lesson: cond_lesson, position: 1) do |e|
  e.title = "Is Even?"
  e.title_ru = "Чётное?"
  e.description = "Check if a number is even or odd."
  e.description_ru = "Проверьте, является ли число чётным или нечётным."
  e.instructions = <<~MD
    Create a function `even?` that returns `true` if a number is even, `false` otherwise.

    Hint: Use the modulo operator `%` to check divisibility.
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `even?`, которая возвращает `true`, если число чётное, иначе `false`.

    Подсказка: Используйте оператор остатка `%` для проверки делимости.
  MD
  e.hints = [
    "A number is even if n % 2 == 0",
    "Ruby has a built-in .even? method on integers",
    "You can use either approach"
  ]
  e.hints_ru = [
    "Число чётное, если n % 2 == 0",
    "У Ruby есть встроенный метод .even? для целых чисел",
    "Можете использовать любой подход"
  ]
  e.starter_code = "def even?(n)\n  # Your code here\nend"
  e.solution_code = "def even?(n)\n  n % 2 == 0\nend"
  e.test_code = <<~RUBY
    RSpec.describe "even?" do
      it "returns true for 0" do
        expect(even?(0)).to be true
      end

      it "returns true for 2" do
        expect(even?(2)).to be true
      end

      it "returns false for 1" do
        expect(even?(1)).to be false
      end

      it "returns true for negative even" do
        expect(even?(-4)).to be true
      end

      it "returns false for negative odd" do
        expect(even?(-3)).to be false
      end
    end
  RUBY
  e.topics = [ "conditionals", "boolean", "modulo" ]
  e.points = 10
end

Exercise.find_or_create_by!(lesson: cond_lesson, position: 2) do |e|
  e.title = "FizzBuzz"
  e.title_ru = "FizzBuzz"
  e.description = "The classic programming challenge!"
  e.description_ru = "Классическая задача программирования!"
  e.instructions = <<~MD
    Create a function `fizzbuzz` that takes a number and returns:

    - "FizzBuzz" if the number is divisible by both 3 and 5
    - "Fizz" if the number is divisible by 3
    - "Buzz" if the number is divisible by 5
    - The number as a string otherwise
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `fizzbuzz`, которая принимает число и возвращает:

    - "FizzBuzz" если число делится на 3 и на 5
    - "Fizz" если число делится на 3
    - "Buzz" если число делится на 5
    - Число в виде строки в остальных случаях
  MD
  e.hints = [
    "Check divisibility by both 3 and 5 first",
    "Use n % 3 == 0 to check divisibility by 3",
    "Use .to_s to convert number to string"
  ]
  e.hints_ru = [
    "Сначала проверьте делимость на 3 и 5 одновременно",
    "Используйте n % 3 == 0 для проверки делимости на 3",
    "Используйте .to_s для преобразования числа в строку"
  ]
  e.starter_code = <<~RUBY
    def fizzbuzz(n)
      # Your code here
    end
  RUBY
  e.solution_code = <<~RUBY
    def fizzbuzz(n)
      if n % 15 == 0
        "FizzBuzz"
      elsif n % 3 == 0
        "Fizz"
      elsif n % 5 == 0
        "Buzz"
      else
        n.to_s
      end
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "fizzbuzz" do
      it "returns Fizz for 3" do
        expect(fizzbuzz(3)).to eq("Fizz")
      end

      it "returns Buzz for 5" do
        expect(fizzbuzz(5)).to eq("Buzz")
      end

      it "returns FizzBuzz for 15" do
        expect(fizzbuzz(15)).to eq("FizzBuzz")
      end

      it "returns the number as string for 7" do
        expect(fizzbuzz(7)).to eq("7")
      end

      it "returns FizzBuzz for 30" do
        expect(fizzbuzz(30)).to eq("FizzBuzz")
      end
    end
  RUBY
  e.topics = [ "conditionals", "divisibility", "classic" ]
  e.points = 20
end

Exercise.find_or_create_by!(lesson: cond_lesson, position: 3) do |e|
  e.title = "Grade Calculator"
  e.title_ru = "Калькулятор оценок"
  e.description = "Convert a numeric score to a letter grade."
  e.description_ru = "Преобразуйте числовой балл в буквенную оценку."
  e.instructions = <<~MD
    Create a function `grade` that takes a score (0-100) and returns a letter grade:

    - 90-100: "A"
    - 80-89: "B"
    - 70-79: "C"
    - 60-69: "D"
    - Below 60: "F"
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `grade`, которая принимает балл (0-100) и возвращает буквенную оценку:

    - 90-100: "A"
    - 80-89: "B"
    - 70-79: "C"
    - 60-69: "D"
    - Ниже 60: "F"
  MD
  e.hints = [
    "Use if/elsif/else or case statement",
    "Check from highest to lowest",
    "You can use ranges with case: when 90..100"
  ]
  e.hints_ru = [
    "Используйте if/elsif/else или оператор case",
    "Проверяйте от большего к меньшему",
    "Можете использовать диапазоны с case: when 90..100"
  ]
  e.starter_code = <<~RUBY
    def grade(score)
      # Your code here
    end
  RUBY
  e.solution_code = <<~RUBY
    def grade(score)
      case score
      when 90..100 then "A"
      when 80..89 then "B"
      when 70..79 then "C"
      when 60..69 then "D"
      else "F"
      end
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "grade" do
      it "returns A for 95" do
        expect(grade(95)).to eq("A")
      end

      it "returns A for 90" do
        expect(grade(90)).to eq("A")
      end

      it "returns B for 85" do
        expect(grade(85)).to eq("B")
      end

      it "returns C for 75" do
        expect(grade(75)).to eq("C")
      end

      it "returns D for 65" do
        expect(grade(65)).to eq("D")
      end

      it "returns F for 55" do
        expect(grade(55)).to eq("F")
      end
    end
  RUBY
  e.topics = [ "conditionals", "case", "ranges" ]
  e.points = 15
end

# =============================================================================
# MODULE 2: Working with Data
# =============================================================================

# Arrays Lesson
arrays_lesson = Lesson.find_or_create_by!(module_number: 2, position: 1) do |l|
  l.title = "Arrays"
  l.title_ru = "Массивы"
  l.description = "Master Ruby arrays with powerful built-in methods for data manipulation."
  l.description_ru = "Освойте массивы Ruby с мощными встроенными методами для работы с данными."
  l.difficulty = :beginner
  l.ruby_version = "3.4"
end

Exercise.find_or_create_by!(lesson: arrays_lesson, position: 1) do |e|
  e.title = "First and Last"
  e.title_ru = "Первый и последний"
  e.description = "Get the first and last elements of an array."
  e.description_ru = "Получите первый и последний элементы массива."
  e.instructions = <<~MD
    Create a function `first_and_last` that takes an array and returns
    a new array containing only the first and last elements.

    Example: `first_and_last([1, 2, 3, 4])` returns `[1, 4]`
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `first_and_last`, которая принимает массив и возвращает
    новый массив, содержащий только первый и последний элементы.

    Пример: `first_and_last([1, 2, 3, 4])` возвращает `[1, 4]`
  MD
  e.hints = [
    "Use array.first and array.last",
    "Return a new array with [first, last]",
    "Handle edge cases like empty arrays"
  ]
  e.hints_ru = [
    "Используйте array.first и array.last",
    "Верните новый массив [first, last]",
    "Обработайте граничные случаи, например пустые массивы"
  ]
  e.starter_code = <<~RUBY
    def first_and_last(arr)
      # Your code here
    end
  RUBY
  e.solution_code = <<~RUBY
    def first_and_last(arr)
      [arr.first, arr.last]
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "first_and_last" do
      it "returns first and last of [1,2,3,4]" do
        expect(first_and_last([1, 2, 3, 4])).to eq([1, 4])
      end

      it "returns same element twice for single item" do
        expect(first_and_last([5])).to eq([5, 5])
      end

      it "works with strings" do
        expect(first_and_last(["a", "b", "c"])).to eq(["a", "c"])
      end
    end
  RUBY
  e.topics = [ "arrays", "first", "last" ]
  e.points = 10
end

Exercise.find_or_create_by!(lesson: arrays_lesson, position: 2) do |e|
  e.title = "Double Each"
  e.title_ru = "Удвоить каждый"
  e.description = "Transform each element in an array."
  e.description_ru = "Преобразуйте каждый элемент массива."
  e.instructions = <<~MD
    Create a function `double_each` that takes an array of numbers
    and returns a new array with each number doubled.

    Use the `map` method for this transformation.
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `double_each`, которая принимает массив чисел
    и возвращает новый массив с удвоенными числами.

    Используйте метод `map` для преобразования.
  MD
  e.hints = [
    "Use .map to transform each element",
    "map returns a new array",
    "Example: [1,2].map { |n| n * 2 } returns [2,4]"
  ]
  e.hints_ru = [
    "Используйте .map для преобразования каждого элемента",
    "map возвращает новый массив",
    "Пример: [1,2].map { |n| n * 2 } возвращает [2,4]"
  ]
  e.starter_code = <<~RUBY
    def double_each(numbers)
      # Your code here
    end
  RUBY
  e.solution_code = <<~RUBY
    def double_each(numbers)
      numbers.map { |n| n * 2 }
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "double_each" do
      it "doubles each number" do
        expect(double_each([1, 2, 3])).to eq([2, 4, 6])
      end

      it "handles empty array" do
        expect(double_each([])).to eq([])
      end

      it "handles negative numbers" do
        expect(double_each([-1, -2])).to eq([-2, -4])
      end
    end
  RUBY
  e.topics = [ "arrays", "map", "transformation" ]
  e.points = 15
end

Exercise.find_or_create_by!(lesson: arrays_lesson, position: 3) do |e|
  e.title = "Select Evens"
  e.title_ru = "Выбрать чётные"
  e.description = "Filter an array to keep only even numbers."
  e.description_ru = "Отфильтруйте массив, оставив только чётные числа."
  e.instructions = <<~MD
    Create a function `select_evens` that takes an array of numbers
    and returns a new array containing only the even numbers.

    Use the `select` method for filtering.
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `select_evens`, которая принимает массив чисел
    и возвращает новый массив только с чётными числами.

    Используйте метод `select` для фильтрации.
  MD
  e.hints = [
    "Use .select to filter elements",
    "select keeps elements where the block returns true",
    "Use n.even? or n % 2 == 0"
  ]
  e.hints_ru = [
    "Используйте .select для фильтрации элементов",
    "select оставляет элементы, для которых блок возвращает true",
    "Используйте n.even? или n % 2 == 0"
  ]
  e.starter_code = <<~RUBY
    def select_evens(numbers)
      # Your code here
    end
  RUBY
  e.solution_code = <<~RUBY
    def select_evens(numbers)
      numbers.select { |n| n.even? }
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "select_evens" do
      it "selects even numbers" do
        expect(select_evens([1, 2, 3, 4, 5, 6])).to eq([2, 4, 6])
      end

      it "returns empty for all odds" do
        expect(select_evens([1, 3, 5])).to eq([])
      end

      it "handles empty array" do
        expect(select_evens([])).to eq([])
      end
    end
  RUBY
  e.topics = [ "arrays", "select", "filter" ]
  e.points = 15
end

Exercise.find_or_create_by!(lesson: arrays_lesson, position: 4) do |e|
  e.title = "Find Maximum"
  e.title_ru = "Найти максимум"
  e.description = "Find the largest element in an array."
  e.description_ru = "Найдите наибольший элемент в массиве."
  e.instructions = <<~MD
    Create a function `find_max` that takes an array of numbers
    and returns the largest number.

    Hint: Arrays have a built-in `max` method!
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `find_max`, которая принимает массив чисел
    и возвращает наибольшее число.

    Подсказка: у массивов есть встроенный метод `max`!
  MD
  e.hints = [
    "Use .max method",
    "Or use .reduce with comparison",
    "Handle empty arrays (return nil)"
  ]
  e.hints_ru = [
    "Используйте метод .max",
    "Или используйте .reduce со сравнением",
    "Обработайте пустые массивы (верните nil)"
  ]
  e.starter_code = <<~RUBY
    def find_max(numbers)
      # Your code here
    end
  RUBY
  e.solution_code = <<~RUBY
    def find_max(numbers)
      numbers.max
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "find_max" do
      it "finds max in positive numbers" do
        expect(find_max([1, 5, 3, 9, 2])).to eq(9)
      end

      it "finds max with negative numbers" do
        expect(find_max([-5, -1, -10])).to eq(-1)
      end

      it "returns nil for empty array" do
        expect(find_max([])).to be_nil
      end
    end
  RUBY
  e.topics = [ "arrays", "max", "comparison" ]
  e.points = 10
end

Exercise.find_or_create_by!(lesson: arrays_lesson, position: 5) do |e|
  e.title = "Symbol to Proc"
  e.title_ru = "Symbol в Proc"
  e.description = "Learn the &:method shorthand for calling methods on each element."
  e.description_ru = "Изучите сокращённую запись &:метод для вызова методов на каждом элементе."
  e.instructions = <<~MD
    Ruby has a powerful shorthand for calling a method on each element.

    Instead of:
    ```ruby
    words.map { |w| w.upcase }
    ```

    You can write:
    ```ruby
    words.map(&:upcase)
    ```

    The `&:method_name` converts a symbol to a proc that calls that method.

    Create a function `lengths` that returns the length of each string
    in an array using the `&:method` syntax.
  MD
  e.instructions_ru = <<~MD
    В Ruby есть мощная сокращённая запись для вызова метода на каждом элементе.

    Вместо:
    ```ruby
    words.map { |w| w.upcase }
    ```

    Можно написать:
    ```ruby
    words.map(&:upcase)
    ```

    `&:имя_метода` преобразует символ в proc, который вызывает этот метод.

    Создайте функцию `lengths`, которая возвращает длину каждой строки
    в массиве, используя синтаксис `&:метод`.
  MD
  e.hints = [
    "Use .map(&:length)",
    "&:length is equivalent to { |s| s.length }",
    "This works with any method that takes no arguments"
  ]
  e.hints_ru = [
    "Используйте .map(&:length)",
    "&:length эквивалентно { |s| s.length }",
    "Это работает с любым методом без аргументов"
  ]
  e.starter_code = <<~RUBY
    def lengths(strings)
      # Use &:method syntax
    end
  RUBY
  e.solution_code = <<~RUBY
    def lengths(strings)
      strings.map(&:length)
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "lengths with &:method" do
      it "returns length of each string" do
        expect(lengths(["hello", "world", "ruby"])).to eq([5, 5, 4])
      end

      it "handles empty array" do
        expect(lengths([])).to eq([])
      end

      it "handles empty strings" do
        expect(lengths(["", "a", "ab"])).to eq([0, 1, 2])
      end
    end
  RUBY
  e.topics = [ "arrays", "symbol to proc", "shorthand", "functional" ]
  e.points = 15
end

Exercise.find_or_create_by!(lesson: arrays_lesson, position: 6) do |e|
  e.title = "Find First Match"
  e.title_ru = "Найти первое совпадение"
  e.description = "Use find to get the first element matching a condition."
  e.description_ru = "Используйте find для получения первого элемента, соответствующего условию."
  e.instructions = <<~MD
    Create a function `first_long_word` that returns the first word
    longer than 5 characters from an array.

    Use the `find` method (also called `detect`):
    ```ruby
    [1, 2, 3].find { |n| n > 1 }  # => 2
    ```

    `find` returns the first matching element, or `nil` if none found.
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `first_long_word`, которая возвращает первое слово
    длиннее 5 символов из массива.

    Используйте метод `find` (также называется `detect`):
    ```ruby
    [1, 2, 3].find { |n| n > 1 }  # => 2
    ```

    `find` возвращает первый подходящий элемент или `nil`, если ничего не найдено.
  MD
  e.hints = [
    "Use .find { |word| word.length > 5 }",
    "find returns nil if no match",
    "It stops searching after first match"
  ]
  e.hints_ru = [
    "Используйте .find { |word| word.length > 5 }",
    "find возвращает nil, если ничего не найдено",
    "Поиск останавливается после первого совпадения"
  ]
  e.starter_code = <<~RUBY
    def first_long_word(words)
      # Use find to get first word longer than 5 chars
    end
  RUBY
  e.solution_code = <<~RUBY
    def first_long_word(words)
      words.find { |word| word.length > 5 }
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "first_long_word" do
      it "finds first word longer than 5 chars" do
        expect(first_long_word(["hi", "hello", "programming", "ruby"])).to eq("programming")
      end

      it "returns nil when no match" do
        expect(first_long_word(["a", "bb", "ccc"])).to be_nil
      end

      it "returns first match, not all matches" do
        expect(first_long_word(["short", "medium", "another"])).to eq("medium")
      end

      it "handles empty array" do
        expect(first_long_word([])).to be_nil
      end
    end
  RUBY
  e.topics = [ "arrays", "find", "detect", "first match" ]
  e.points = 15
end

# Hashes Lesson
hashes_lesson = Lesson.find_or_create_by!(module_number: 2, position: 2) do |l|
  l.title = "Hashes"
  l.title_ru = "Хеши"
  l.description = "Learn to work with Ruby's powerful key-value data structure."
  l.description_ru = "Научитесь работать с мощной структурой данных Ruby — хешами."
  l.difficulty = :intermediate
  l.ruby_version = "3.4"
end

Exercise.find_or_create_by!(lesson: hashes_lesson, position: 1) do |e|
  e.title = "Create a Person Hash"
  e.title_ru = "Создание хеша человека"
  e.description = "Build a hash with person information."
  e.description_ru = "Создайте хеш с информацией о человеке."
  e.instructions = <<~MD
    Create a function `create_person` that takes a name and age
    and returns a hash with `:name` and `:age` keys.

    Example: `create_person("Alice", 30)` returns `{name: "Alice", age: 30}`
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `create_person`, которая принимает имя и возраст
    и возвращает хеш с ключами `:name` и `:age`.

    Пример: `create_person("Alice", 30)` возвращает `{name: "Alice", age: 30}`
  MD
  e.hints = [
    "Use symbol keys: { name: value, age: value }",
    "Or use the arrow syntax: { :name => value }",
    "Both syntaxes work the same way"
  ]
  e.hints_ru = [
    "Используйте символы как ключи: { name: value, age: value }",
    "Или используйте синтаксис со стрелкой: { :name => value }",
    "Оба синтаксиса работают одинаково"
  ]
  e.starter_code = <<~RUBY
    def create_person(name, age)
      # Your code here
    end
  RUBY
  e.solution_code = <<~RUBY
    def create_person(name, age)
      { name: name, age: age }
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "create_person" do
      it "creates a person hash" do
        expect(create_person("Alice", 30)).to eq({ name: "Alice", age: 30 })
      end

      it "works with different values" do
        expect(create_person("Bob", 25)).to eq({ name: "Bob", age: 25 })
      end
    end
  RUBY
  e.topics = [ "hashes", "symbols", "data structures" ]
  e.points = 10
end

Exercise.find_or_create_by!(lesson: hashes_lesson, position: 2) do |e|
  e.title = "Get Hash Value"
  e.title_ru = "Получение значения хеша"
  e.description = "Safely retrieve values from a hash with defaults."
  e.description_ru = "Безопасно получайте значения из хеша с значениями по умолчанию."
  e.instructions = <<~MD
    Create a function `get_value` that takes a hash, a key, and a default value.
    Return the value for the key if it exists, otherwise return the default.

    Use Ruby's `fetch` method with a default value.
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `get_value`, которая принимает хеш, ключ и значение по умолчанию.
    Верните значение для ключа, если он существует, иначе верните значение по умолчанию.

    Используйте метод `fetch` с значением по умолчанию.
  MD
  e.hints = [
    "Use hash.fetch(key, default)",
    "fetch returns default if key doesn't exist",
    "This is safer than hash[key] || default"
  ]
  e.hints_ru = [
    "Используйте hash.fetch(key, default)",
    "fetch возвращает default, если ключа нет",
    "Это безопаснее, чем hash[key] || default"
  ]
  e.starter_code = <<~RUBY
    def get_value(hash, key, default)
      # Your code here
    end
  RUBY
  e.solution_code = <<~RUBY
    def get_value(hash, key, default)
      hash.fetch(key, default)
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "get_value" do
      it "returns value when key exists" do
        expect(get_value({ a: 1, b: 2 }, :a, 0)).to eq(1)
      end

      it "returns default when key missing" do
        expect(get_value({ a: 1 }, :b, 99)).to eq(99)
      end

      it "works with string keys" do
        expect(get_value({ "x" => 10 }, "x", 0)).to eq(10)
      end
    end
  RUBY
  e.topics = [ "hashes", "fetch", "defaults" ]
  e.points = 15
end

Exercise.find_or_create_by!(lesson: hashes_lesson, position: 3) do |e|
  e.title = "Count Words"
  e.title_ru = "Подсчёт слов"
  e.description = "Count word frequencies in a sentence."
  e.description_ru = "Подсчитайте частоту слов в предложении."
  e.instructions = <<~MD
    Create a function `count_words` that takes a string and returns
    a hash with each word as a key and its count as the value.

    - Convert words to lowercase
    - Split on spaces

    Example: `count_words("hello world hello")` returns `{"hello" => 2, "world" => 1}`
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `count_words`, которая принимает строку и возвращает
    хеш, где каждое слово — ключ, а его количество — значение.

    - Приведите слова к нижнему регистру
    - Разделите по пробелам

    Пример: `count_words("hello world hello")` возвращает `{"hello" => 2, "world" => 1}`
  MD
  e.hints = [
    "Use .downcase.split to get words",
    "Use .tally for counting (Ruby 2.7+)",
    "Or use .each_with_object({}) with incrementing"
  ]
  e.hints_ru = [
    "Используйте .downcase.split для получения слов",
    "Используйте .tally для подсчёта (Ruby 2.7+)",
    "Или используйте .each_with_object({}) с инкрементом"
  ]
  e.starter_code = <<~RUBY
    def count_words(sentence)
      # Your code here
    end
  RUBY
  e.solution_code = <<~RUBY
    def count_words(sentence)
      sentence.downcase.split.tally
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "count_words" do
      it "counts word frequencies" do
        expect(count_words("hello world hello")).to eq({ "hello" => 2, "world" => 1 })
      end

      it "handles single word" do
        expect(count_words("ruby")).to eq({ "ruby" => 1 })
      end

      it "is case insensitive" do
        expect(count_words("Hello HELLO hello")).to eq({ "hello" => 3 })
      end

      it "handles empty string" do
        expect(count_words("")).to eq({})
      end
    end
  RUBY
  e.topics = [ "hashes", "tally", "word count" ]
  e.points = 20
end

Exercise.find_or_create_by!(lesson: hashes_lesson, position: 4) do |e|
  e.title = "Merge Hashes"
  e.title_ru = "Объединение хешей"
  e.description = "Combine two hashes with custom merge logic."
  e.description_ru = "Объедините два хеша с пользовательской логикой слияния."
  e.instructions = <<~MD
    Create a function `merge_with_sum` that takes two hashes with numeric values
    and returns a new hash where values for matching keys are summed.

    Example:
    ```ruby
    merge_with_sum({a: 1, b: 2}, {b: 3, c: 4})
    # => {a: 1, b: 5, c: 4}
    ```
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `merge_with_sum`, которая принимает два хеша с числовыми значениями
    и возвращает новый хеш, где значения совпадающих ключей суммируются.

    Пример:
    ```ruby
    merge_with_sum({a: 1, b: 2}, {b: 3, c: 4})
    # => {a: 1, b: 5, c: 4}
    ```
  MD
  e.hints = [
    "Use .merge with a block",
    "The block receives key, old_val, new_val",
    "Return old_val + new_val in the block"
  ]
  e.hints_ru = [
    "Используйте .merge с блоком",
    "Блок получает key, old_val, new_val",
    "Верните old_val + new_val в блоке"
  ]
  e.starter_code = <<~RUBY
    def merge_with_sum(hash1, hash2)
      # Your code here
    end
  RUBY
  e.solution_code = <<~RUBY
    def merge_with_sum(hash1, hash2)
      hash1.merge(hash2) { |_key, v1, v2| v1 + v2 }
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "merge_with_sum" do
      it "sums overlapping keys" do
        result = merge_with_sum({ a: 1, b: 2 }, { b: 3, c: 4 })
        expect(result).to eq({ a: 1, b: 5, c: 4 })
      end

      it "handles non-overlapping hashes" do
        result = merge_with_sum({ a: 1 }, { b: 2 })
        expect(result).to eq({ a: 1, b: 2 })
      end

      it "handles empty hash" do
        result = merge_with_sum({}, { a: 1 })
        expect(result).to eq({ a: 1 })
      end
    end
  RUBY
  e.topics = [ "hashes", "merge", "blocks" ]
  e.points = 20
end

# Strings Lesson
strings_lesson = Lesson.find_or_create_by!(module_number: 2, position: 3) do |l|
  l.title = "Strings"
  l.title_ru = "Строки"
  l.description = "Master string manipulation with Ruby's rich string methods."
  l.description_ru = "Освойте работу со строками с помощью богатых методов Ruby."
  l.difficulty = :beginner
  l.ruby_version = "3.4"
end

Exercise.find_or_create_by!(lesson: strings_lesson, position: 1) do |e|
  e.title = "Reverse a String"
  e.title_ru = "Перевернуть строку"
  e.description = "Reverse the characters in a string."
  e.description_ru = "Переверните символы в строке."
  e.instructions = <<~MD
    Create a function `reverse_string` that takes a string and returns it reversed.

    Example: `reverse_string("hello")` returns `"olleh"`
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `reverse_string`, которая принимает строку и возвращает её перевёрнутой.

    Пример: `reverse_string("hello")` возвращает `"olleh"`
  MD
  e.hints = [
    "Ruby strings have a .reverse method",
    "You can also use .chars.reverse.join",
    "The simplest solution is often the best"
  ]
  e.hints_ru = [
    "У строк Ruby есть метод .reverse",
    "Также можно использовать .chars.reverse.join",
    "Простейшее решение часто лучшее"
  ]
  e.starter_code = <<~RUBY
    def reverse_string(str)
      # Your code here
    end
  RUBY
  e.solution_code = <<~RUBY
    def reverse_string(str)
      str.reverse
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "reverse_string" do
      it "reverses hello" do
        expect(reverse_string("hello")).to eq("olleh")
      end

      it "reverses ruby" do
        expect(reverse_string("ruby")).to eq("ybur")
      end

      it "handles empty string" do
        expect(reverse_string("")).to eq("")
      end

      it "handles single character" do
        expect(reverse_string("a")).to eq("a")
      end
    end
  RUBY
  e.topics = [ "strings", "reverse", "methods" ]
  e.points = 10
end

Exercise.find_or_create_by!(lesson: strings_lesson, position: 2) do |e|
  e.title = "Palindrome Check"
  e.title_ru = "Проверка на палиндром"
  e.description = "Check if a string is a palindrome."
  e.description_ru = "Проверьте, является ли строка палиндромом."
  e.instructions = <<~MD
    Create a function `palindrome?` that returns true if a string
    reads the same forwards and backwards.

    Ignore case when comparing.

    Example: `palindrome?("Racecar")` returns `true`
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `palindrome?`, которая возвращает true, если строка
    читается одинаково слева направо и справа налево.

    Игнорируйте регистр при сравнении.

    Пример: `palindrome?("Racecar")` возвращает `true`
  MD
  e.hints = [
    "Use .downcase to normalize case",
    "Compare string with its reverse",
    "str.downcase == str.downcase.reverse"
  ]
  e.hints_ru = [
    "Используйте .downcase для нормализации регистра",
    "Сравните строку с её перевёрнутой версией",
    "str.downcase == str.downcase.reverse"
  ]
  e.starter_code = <<~RUBY
    def palindrome?(str)
      # Your code here
    end
  RUBY
  e.solution_code = <<~RUBY
    def palindrome?(str)
      str.downcase == str.downcase.reverse
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "palindrome?" do
      it "returns true for racecar" do
        expect(palindrome?("racecar")).to be true
      end

      it "is case insensitive" do
        expect(palindrome?("Racecar")).to be true
      end

      it "returns false for hello" do
        expect(palindrome?("hello")).to be false
      end

      it "returns true for single char" do
        expect(palindrome?("a")).to be true
      end
    end
  RUBY
  e.topics = [ "strings", "palindrome", "comparison" ]
  e.points = 15
end

Exercise.find_or_create_by!(lesson: strings_lesson, position: 3) do |e|
  e.title = "Title Case"
  e.title_ru = "Заглавные буквы"
  e.description = "Convert a string to title case."
  e.description_ru = "Преобразуйте строку в заглавный регистр."
  e.instructions = <<~MD
    Create a function `titleize` that converts a string to title case,
    where the first letter of each word is capitalized.

    Example: `titleize("hello world")` returns `"Hello World"`
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `titleize`, которая преобразует строку в заглавный регистр,
    где первая буква каждого слова заглавная.

    Пример: `titleize("hello world")` возвращает `"Hello World"`
  MD
  e.hints = [
    "Split into words, capitalize each, join back",
    "Use .split, .map, and .join",
    "Each word: word.capitalize"
  ]
  e.hints_ru = [
    "Разделите на слова, сделайте каждое с заглавной, соедините обратно",
    "Используйте .split, .map и .join",
    "Для каждого слова: word.capitalize"
  ]
  e.starter_code = <<~RUBY
    def titleize(str)
      # Your code here
    end
  RUBY
  e.solution_code = <<~RUBY
    def titleize(str)
      str.split.map(&:capitalize).join(" ")
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "titleize" do
      it "titleizes hello world" do
        expect(titleize("hello world")).to eq("Hello World")
      end

      it "handles mixed case" do
        expect(titleize("hELLO wORLD")).to eq("Hello World")
      end

      it "handles single word" do
        expect(titleize("ruby")).to eq("Ruby")
      end
    end
  RUBY
  e.topics = [ "strings", "capitalize", "transformation" ]
  e.points = 15
end

Exercise.find_or_create_by!(lesson: strings_lesson, position: 4) do |e|
  e.title = "Anagram Check"
  e.title_ru = "Проверка на анаграмму"
  e.description = "Check if two strings are anagrams."
  e.description_ru = "Проверьте, являются ли две строки анаграммами."
  e.instructions = <<~MD
    Create a function `anagram?` that returns true if two strings
    are anagrams of each other (contain the same letters).

    - Ignore case
    - Ignore spaces

    Example: `anagram?("listen", "silent")` returns `true`
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `anagram?`, которая возвращает true, если две строки
    являются анаграммами (содержат одинаковые буквы).

    - Игнорируйте регистр
    - Игнорируйте пробелы

    Пример: `anagram?("listen", "silent")` возвращает `true`
  MD
  e.hints = [
    "Remove spaces and downcase both strings",
    "Sort the characters and compare",
    "str.gsub(' ', '').downcase.chars.sort"
  ]
  e.hints_ru = [
    "Удалите пробелы и приведите обе строки к нижнему регистру",
    "Отсортируйте символы и сравните",
    "str.gsub(' ', '').downcase.chars.sort"
  ]
  e.starter_code = <<~RUBY
    def anagram?(str1, str2)
      # Your code here
    end
  RUBY
  e.solution_code = <<~RUBY
    def anagram?(str1, str2)
      normalize = ->(s) { s.gsub(" ", "").downcase.chars.sort }
      normalize.call(str1) == normalize.call(str2)
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "anagram?" do
      it "returns true for listen/silent" do
        expect(anagram?("listen", "silent")).to be true
      end

      it "is case insensitive" do
        expect(anagram?("Listen", "Silent")).to be true
      end

      it "ignores spaces" do
        expect(anagram?("rail safety", "fairy tales")).to be true
      end

      it "returns false for non-anagrams" do
        expect(anagram?("hello", "world")).to be false
      end
    end
  RUBY
  e.topics = [ "strings", "anagram", "sorting" ]
  e.points = 20
end

Exercise.find_or_create_by!(lesson: strings_lesson, position: 5) do |e|
  e.title = "Extract Numbers"
  e.title_ru = "Извлечь числа"
  e.description = "Use regular expressions to find all numbers in a string."
  e.description_ru = "Используйте регулярные выражения для поиска всех чисел в строке."
  e.instructions = <<~MD
    Create a function `extract_numbers` that takes a string and returns
    an array of all integers found in that string.

    Use Ruby's `scan` method with a regular expression:
    ```ruby
    "abc".scan(/pattern/)  # Returns array of matches
    ```

    The regex `\\d+` matches one or more digits.

    Example:
    ```ruby
    extract_numbers("I have 3 cats and 2 dogs")
    # => [3, 2]
    ```
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `extract_numbers`, которая принимает строку и возвращает
    массив всех целых чисел, найденных в этой строке.

    Используйте метод `scan` с регулярным выражением:
    ```ruby
    "abc".scan(/pattern/)  # Возвращает массив совпадений
    ```

    Regex `\\d+` соответствует одной или более цифрам.

    Пример:
    ```ruby
    extract_numbers("I have 3 cats and 2 dogs")
    # => [3, 2]
    ```
  MD
  e.hints = [
    "Use .scan(/\\d+/) to find all digit sequences",
    "scan returns strings, use .map(&:to_i) to convert",
    "\\d matches any digit, + means one or more"
  ]
  e.hints_ru = [
    "Используйте .scan(/\\d+/) для поиска всех последовательностей цифр",
    "scan возвращает строки, используйте .map(&:to_i) для преобразования",
    "\\d соответствует любой цифре, + означает одну или более"
  ]
  e.starter_code = <<~RUBY
    def extract_numbers(str)
      # Use scan with regex to find numbers
    end
  RUBY
  e.solution_code = <<~RUBY
    def extract_numbers(str)
      str.scan(/\\d+/).map(&:to_i)
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "extract_numbers" do
      it "extracts numbers from text" do
        expect(extract_numbers("I have 3 cats and 2 dogs")).to eq([3, 2])
      end

      it "handles multiple digits" do
        expect(extract_numbers("Order 123 has 45 items")).to eq([123, 45])
      end

      it "returns empty array when no numbers" do
        expect(extract_numbers("no numbers here")).to eq([])
      end

      it "handles string with only numbers" do
        expect(extract_numbers("42")).to eq([42])
      end

      it "handles adjacent numbers with text" do
        expect(extract_numbers("a1b2c3")).to eq([1, 2, 3])
      end
    end
  RUBY
  e.topics = [ "strings", "regex", "scan", "pattern matching" ]
  e.points = 20
end

Exercise.find_or_create_by!(lesson: strings_lesson, position: 6) do |e|
  e.title = "Validate Email"
  e.title_ru = "Проверка email"
  e.description = "Use regex to validate a simple email format."
  e.description_ru = "Используйте regex для проверки простого формата email."
  e.instructions = <<~MD
    Create a function `valid_email?` that checks if a string looks like
    a valid email address using a regular expression.

    A simple email pattern should match:
    - One or more word characters before @
    - The @ symbol
    - One or more word characters for domain
    - A dot
    - 2-4 letters for TLD

    Use `match?` to check if a string matches a pattern:
    ```ruby
    "test".match?(/pattern/)  # Returns true or false
    ```
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `valid_email?`, которая проверяет, похожа ли строка
    на действительный email-адрес, используя регулярное выражение.

    Простой шаблон email должен соответствовать:
    - Один или более символов слова перед @
    - Символ @
    - Один или более символов слова для домена
    - Точка
    - 2-4 буквы для TLD

    Используйте `match?` для проверки соответствия строки шаблону:
    ```ruby
    "test".match?(/pattern/)  # Возвращает true или false
    ```
  MD
  e.hints = [
    "Use \\w+ for word characters (letters, digits, underscore)",
    "Escape the dot with \\.",
    "Pattern: /\\w+@\\w+\\.\\w{2,4}/"
  ]
  e.hints_ru = [
    "Используйте \\w+ для символов слова (буквы, цифры, подчёркивание)",
    "Экранируйте точку с помощью \\.",
    "Шаблон: /\\w+@\\w+\\.\\w{2,4}/"
  ]
  e.starter_code = <<~RUBY
    def valid_email?(email)
      # Use match? with a regex pattern
    end
  RUBY
  e.solution_code = <<~RUBY
    def valid_email?(email)
      email.match?(/\\A\\w+@\\w+\\.\\w{2,4}\\z/)
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "valid_email?" do
      it "returns true for valid email" do
        expect(valid_email?("user@example.com")).to be true
      end

      it "returns true for email with numbers" do
        expect(valid_email?("user123@test.org")).to be true
      end

      it "returns false without @" do
        expect(valid_email?("userexample.com")).to be false
      end

      it "returns false without domain" do
        expect(valid_email?("user@.com")).to be false
      end

      it "returns false without TLD" do
        expect(valid_email?("user@example")).to be false
      end
    end
  RUBY
  e.topics = [ "strings", "regex", "validation", "match" ]
  e.points = 25
end

# Intermediate Enumerables Lesson
enumerables_lesson = Lesson.find_or_create_by!(module_number: 2, position: 4) do |l|
  l.title = "Intermediate Enumerables"
  l.title_ru = "Продвинутые Enumerable методы"
  l.description = "Master advanced enumerable methods for powerful data processing."
  l.description_ru = "Освойте продвинутые методы Enumerable для мощной обработки данных."
  l.difficulty = :intermediate
  l.ruby_version = "3.4"
end

Exercise.find_or_create_by!(lesson: enumerables_lesson, position: 1) do |e|
  e.title = "Check All Elements"
  e.title_ru = "Проверка всех элементов"
  e.description = "Use all? and any? to check conditions across a collection."
  e.description_ru = "Используйте all? и any? для проверки условий в коллекции."
  e.instructions = <<~MD
    Create two functions:

    1. `all_positive?(numbers)` - returns true if ALL numbers are positive
    2. `any_negative?(numbers)` - returns true if ANY number is negative

    Use the `all?` and `any?` methods:
    ```ruby
    [1, 2, 3].all? { |n| n > 0 }  # => true
    [1, -2, 3].any? { |n| n < 0 } # => true
    ```
  MD
  e.instructions_ru = <<~MD
    Создайте две функции:

    1. `all_positive?(numbers)` - возвращает true, если ВСЕ числа положительные
    2. `any_negative?(numbers)` - возвращает true, если ХОТЯ БЫ ОДНО число отрицательное

    Используйте методы `all?` и `any?`:
    ```ruby
    [1, 2, 3].all? { |n| n > 0 }  # => true
    [1, -2, 3].any? { |n| n < 0 } # => true
    ```
  MD
  e.hints = [
    "all? returns true only if block is true for every element",
    "any? returns true if block is true for at least one element",
    "Empty array: all? returns true, any? returns false"
  ]
  e.hints_ru = [
    "all? возвращает true только если блок вернул true для каждого элемента",
    "any? возвращает true если блок вернул true хотя бы для одного элемента",
    "Для пустого массива: all? возвращает true, any? возвращает false"
  ]
  e.starter_code = <<~RUBY
    def all_positive?(numbers)
      # Check if all numbers are > 0
    end

    def any_negative?(numbers)
      # Check if any number is < 0
    end
  RUBY
  e.solution_code = <<~RUBY
    def all_positive?(numbers)
      numbers.all? { |n| n > 0 }
    end

    def any_negative?(numbers)
      numbers.any? { |n| n < 0 }
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "all? and any?" do
      describe "all_positive?" do
        it "returns true when all positive" do
          expect(all_positive?([1, 2, 3])).to be true
        end

        it "returns false when one negative" do
          expect(all_positive?([1, -2, 3])).to be false
        end

        it "returns true for empty array" do
          expect(all_positive?([])).to be true
        end
      end

      describe "any_negative?" do
        it "returns true when one negative" do
          expect(any_negative?([1, -2, 3])).to be true
        end

        it "returns false when all positive" do
          expect(any_negative?([1, 2, 3])).to be false
        end

        it "returns false for empty array" do
          expect(any_negative?([])).to be false
        end
      end
    end
  RUBY
  e.topics = [ "enumerables", "all?", "any?", "predicates" ]
  e.points = 15
end

Exercise.find_or_create_by!(lesson: enumerables_lesson, position: 2) do |e|
  e.title = "Group By"
  e.title_ru = "Группировка"
  e.description = "Group elements by a common attribute."
  e.description_ru = "Группируйте элементы по общему признаку."
  e.instructions = <<~MD
    Create a function `group_by_length` that takes an array of strings
    and returns a hash where keys are string lengths and values are
    arrays of strings with that length.

    Use the `group_by` method:
    ```ruby
    ["a", "bb", "c"].group_by { |s| s.length }
    # => {1 => ["a", "c"], 2 => ["bb"]}
    ```
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `group_by_length`, которая принимает массив строк
    и возвращает хеш, где ключи — длины строк, а значения — массивы
    строк соответствующей длины.

    Используйте метод `group_by`:
    ```ruby
    ["a", "bb", "c"].group_by { |s| s.length }
    # => {1 => ["a", "c"], 2 => ["bb"]}
    ```
  MD
  e.hints = [
    "Use .group_by { |word| word.length }",
    "group_by returns a hash automatically",
    "Keys are the block return values"
  ]
  e.hints_ru = [
    "Используйте .group_by { |word| word.length }",
    "group_by автоматически возвращает хеш",
    "Ключами становятся возвращаемые значения блока"
  ]
  e.starter_code = <<~RUBY
    def group_by_length(words)
      # Group words by their length
    end
  RUBY
  e.solution_code = <<~RUBY
    def group_by_length(words)
      words.group_by { |word| word.length }
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "group_by_length" do
      it "groups words by length" do
        result = group_by_length(["hi", "hello", "hey", "world"])
        expect(result[2]).to eq(["hi"])
        expect(result[3]).to eq(["hey"])
        expect(result[5]).to contain_exactly("hello", "world")
      end

      it "handles empty array" do
        expect(group_by_length([])).to eq({})
      end

      it "handles single word" do
        expect(group_by_length(["ruby"])).to eq({ 4 => ["ruby"] })
      end
    end
  RUBY
  e.topics = [ "enumerables", "group_by", "hashes", "aggregation" ]
  e.points = 20
end

Exercise.find_or_create_by!(lesson: enumerables_lesson, position: 3) do |e|
  e.title = "Partition"
  e.title_ru = "Разделение"
  e.description = "Split a collection into two groups based on a condition."
  e.description_ru = "Разделите коллекцию на две группы по условию."
  e.instructions = <<~MD
    Create a function `split_by_sign` that takes an array of numbers
    and returns two arrays: one with non-negative numbers (>= 0) and
    one with negative numbers.

    Use the `partition` method:
    ```ruby
    [1, -2, 3, -4].partition { |n| n >= 0 }
    # => [[1, 3], [-2, -4]]
    ```

    Return format: `[non_negatives, negatives]`
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `split_by_sign`, которая принимает массив чисел
    и возвращает два массива: один с неотрицательными числами (>= 0),
    другой с отрицательными.

    Используйте метод `partition`:
    ```ruby
    [1, -2, 3, -4].partition { |n| n >= 0 }
    # => [[1, 3], [-2, -4]]
    ```

    Формат возврата: `[неотрицательные, отрицательные]`
  MD
  e.hints = [
    "partition returns [truthy_elements, falsy_elements]",
    "First array contains elements where block is true",
    "Second array contains elements where block is false"
  ]
  e.hints_ru = [
    "partition возвращает [элементы_true, элементы_false]",
    "Первый массив содержит элементы, для которых блок вернул true",
    "Второй массив содержит элементы, для которых блок вернул false"
  ]
  e.starter_code = <<~RUBY
    def split_by_sign(numbers)
      # Split into [non-negatives, negatives]
    end
  RUBY
  e.solution_code = <<~RUBY
    def split_by_sign(numbers)
      numbers.partition { |n| n >= 0 }
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "split_by_sign" do
      it "splits by sign" do
        positives, negatives = split_by_sign([1, -2, 3, -4, 0])
        expect(positives).to eq([1, 3, 0])
        expect(negatives).to eq([-2, -4])
      end

      it "handles all positive" do
        positives, negatives = split_by_sign([1, 2, 3])
        expect(positives).to eq([1, 2, 3])
        expect(negatives).to eq([])
      end

      it "handles empty array" do
        positives, negatives = split_by_sign([])
        expect(positives).to eq([])
        expect(negatives).to eq([])
      end
    end
  RUBY
  e.topics = [ "enumerables", "partition", "filtering" ]
  e.points = 15
end

Exercise.find_or_create_by!(lesson: enumerables_lesson, position: 4) do |e|
  e.title = "Flat Map"
  e.title_ru = "Плоское отображение"
  e.description = "Transform and flatten nested arrays in one step."
  e.description_ru = "Преобразуйте и разверните вложенные массивы за один шаг."
  e.instructions = <<~MD
    Create a function `all_tags` that takes an array of posts (hashes)
    and returns a flat array of all unique tags.

    Each post has a `:tags` key with an array of strings.

    Use `flat_map` to collect all tags, then `uniq` to remove duplicates:
    ```ruby
    [[1, 2], [3, 4]].flat_map { |arr| arr }
    # => [1, 2, 3, 4]
    ```

    Example:
    ```ruby
    posts = [
      { title: "Ruby", tags: ["ruby", "programming"] },
      { title: "Rails", tags: ["ruby", "rails"] }
    ]
    all_tags(posts)  # => ["ruby", "programming", "rails"]
    ```
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `all_tags`, которая принимает массив постов (хешей)
    и возвращает плоский массив всех уникальных тегов.

    Каждый пост имеет ключ `:tags` с массивом строк.

    Используйте `flat_map` для сбора тегов, затем `uniq` для удаления дубликатов:
    ```ruby
    [[1, 2], [3, 4]].flat_map { |arr| arr }
    # => [1, 2, 3, 4]
    ```

    Пример:
    ```ruby
    posts = [
      { title: "Ruby", tags: ["ruby", "programming"] },
      { title: "Rails", tags: ["ruby", "rails"] }
    ]
    all_tags(posts)  # => ["ruby", "programming", "rails"]
    ```
  MD
  e.hints = [
    "Use .flat_map { |post| post[:tags] }",
    "flat_map = map + flatten(1)",
    "Add .uniq to remove duplicates"
  ]
  e.hints_ru = [
    "Используйте .flat_map { |post| post[:tags] }",
    "flat_map = map + flatten(1)",
    "Добавьте .uniq для удаления дубликатов"
  ]
  e.starter_code = <<~RUBY
    def all_tags(posts)
      # Collect all unique tags from posts
    end
  RUBY
  e.solution_code = <<~RUBY
    def all_tags(posts)
      posts.flat_map { |post| post[:tags] }.uniq
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "all_tags" do
      it "collects unique tags" do
        posts = [
          { title: "Ruby", tags: ["ruby", "programming"] },
          { title: "Rails", tags: ["ruby", "rails"] }
        ]
        expect(all_tags(posts)).to contain_exactly("ruby", "programming", "rails")
      end

      it "handles empty posts" do
        expect(all_tags([])).to eq([])
      end

      it "handles posts with empty tags" do
        posts = [{ title: "No tags", tags: [] }]
        expect(all_tags(posts)).to eq([])
      end
    end
  RUBY
  e.topics = [ "enumerables", "flat_map", "uniq", "nested data" ]
  e.points = 20
end

Exercise.find_or_create_by!(lesson: enumerables_lesson, position: 5) do |e|
  e.title = "Each With Object"
  e.title_ru = "Each With Object"
  e.description = "Build a result object while iterating."
  e.description_ru = "Создайте результирующий объект во время итерации."
  e.instructions = <<~MD
    Create a function `index_by_id` that takes an array of hashes
    (each with an `:id` key) and returns a hash indexed by id.

    Use `each_with_object` to build a hash:
    ```ruby
    [1, 2].each_with_object({}) { |n, hash| hash[n] = n * 2 }
    # => {1 => 2, 2 => 4}
    ```

    Example:
    ```ruby
    users = [
      { id: 1, name: "Alice" },
      { id: 2, name: "Bob" }
    ]
    index_by_id(users)
    # => { 1 => { id: 1, name: "Alice" }, 2 => { id: 2, name: "Bob" } }
    ```
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `index_by_id`, которая принимает массив хешей
    (каждый с ключом `:id`) и возвращает хеш, индексированный по id.

    Используйте `each_with_object` для построения хеша:
    ```ruby
    [1, 2].each_with_object({}) { |n, hash| hash[n] = n * 2 }
    # => {1 => 2, 2 => 4}
    ```

    Пример:
    ```ruby
    users = [
      { id: 1, name: "Alice" },
      { id: 2, name: "Bob" }
    ]
    index_by_id(users)
    # => { 1 => { id: 1, name: "Alice" }, 2 => { id: 2, name: "Bob" } }
    ```
  MD
  e.hints = [
    "Use each_with_object({}) { |item, hash| ... }",
    "Set hash[item[:id]] = item",
    "The result is built incrementally"
  ]
  e.hints_ru = [
    "Используйте each_with_object({}) { |item, hash| ... }",
    "Установите hash[item[:id]] = item",
    "Результат строится постепенно"
  ]
  e.starter_code = <<~RUBY
    def index_by_id(items)
      # Build a hash indexed by :id
    end
  RUBY
  e.solution_code = <<~RUBY
    def index_by_id(items)
      items.each_with_object({}) { |item, hash| hash[item[:id]] = item }
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "index_by_id" do
      it "indexes by id" do
        users = [
          { id: 1, name: "Alice" },
          { id: 2, name: "Bob" }
        ]
        result = index_by_id(users)
        expect(result[1]).to eq({ id: 1, name: "Alice" })
        expect(result[2]).to eq({ id: 2, name: "Bob" })
      end

      it "handles empty array" do
        expect(index_by_id([])).to eq({})
      end
    end
  RUBY
  e.topics = [ "enumerables", "each_with_object", "indexing" ]
  e.points = 20
end

# =============================================================================
# MODULE 3: Object-Oriented Ruby
# =============================================================================

# Classes Lesson
classes_lesson = Lesson.find_or_create_by!(module_number: 3, position: 1) do |l|
  l.title = "Classes and Objects"
  l.title_ru = "Классы и объекты"
  l.description = "Learn to create classes, define methods, and work with objects."
  l.description_ru = "Научитесь создавать классы, определять методы и работать с объектами."
  l.difficulty = :intermediate
  l.ruby_version = "3.4"
end

Exercise.find_or_create_by!(lesson: classes_lesson, position: 1) do |e|
  e.title = "Dog Class"
  e.title_ru = "Класс Dog"
  e.description = "Create a simple Dog class with a name attribute."
  e.description_ru = "Создайте простой класс Dog с атрибутом name."
  e.instructions = <<~MD
    Create a `Dog` class with:

    - An `initialize` method that takes a `name` parameter
    - A `name` reader attribute
    - A `bark` method that returns "Woof!"
  MD
  e.instructions_ru = <<~MD
    Создайте класс `Dog` с:

    - Методом `initialize`, который принимает параметр `name`
    - Атрибутом чтения `name`
    - Методом `bark`, который возвращает "Woof!"
  MD
  e.hints = [
    "Use attr_reader :name",
    "Initialize with @name = name",
    "bark method just returns the string"
  ]
  e.hints_ru = [
    "Используйте attr_reader :name",
    "Инициализируйте с @name = name",
    "Метод bark просто возвращает строку"
  ]
  e.starter_code = <<~RUBY
    class Dog
      # Your code here
    end
  RUBY
  e.solution_code = <<~RUBY
    class Dog
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def bark
        "Woof!"
      end
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe Dog do
      let(:dog) { Dog.new("Buddy") }

      it "has a name" do
        expect(dog.name).to eq("Buddy")
      end

      it "can bark" do
        expect(dog.bark).to eq("Woof!")
      end
    end
  RUBY
  e.topics = [ "classes", "initialize", "attr_reader" ]
  e.points = 15
end

Exercise.find_or_create_by!(lesson: classes_lesson, position: 2) do |e|
  e.title = "Counter Class"
  e.title_ru = "Класс Counter"
  e.description = "Create a Counter class with increment and decrement methods."
  e.description_ru = "Создайте класс Counter с методами инкремента и декремента."
  e.instructions = <<~MD
    Create a `Counter` class with:

    - An `initialize` method that sets count to 0 (or optional starting value)
    - A `count` reader attribute
    - An `increment` method that increases count by 1
    - A `decrement` method that decreases count by 1
  MD
  e.instructions_ru = <<~MD
    Создайте класс `Counter` с:

    - Методом `initialize`, который устанавливает count в 0 (или необязательное начальное значение)
    - Атрибутом чтения `count`
    - Методом `increment`, который увеличивает count на 1
    - Методом `decrement`, который уменьшает count на 1
  MD
  e.hints = [
    "Use attr_reader :count",
    "Use @count += 1 for increment",
    "Default parameter: def initialize(start = 0)"
  ]
  e.hints_ru = [
    "Используйте attr_reader :count",
    "Используйте @count += 1 для инкремента",
    "Параметр по умолчанию: def initialize(start = 0)"
  ]
  e.starter_code = <<~RUBY
    class Counter
      # Your code here
    end
  RUBY
  e.solution_code = <<~RUBY
    class Counter
      attr_reader :count

      def initialize(start = 0)
        @count = start
      end

      def increment
        @count += 1
      end

      def decrement
        @count -= 1
      end
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe Counter do
      it "starts at 0 by default" do
        counter = Counter.new
        expect(counter.count).to eq(0)
      end

      it "can start at custom value" do
        counter = Counter.new(10)
        expect(counter.count).to eq(10)
      end

      it "increments" do
        counter = Counter.new
        counter.increment
        expect(counter.count).to eq(1)
      end

      it "decrements" do
        counter = Counter.new(5)
        counter.decrement
        expect(counter.count).to eq(4)
      end
    end
  RUBY
  e.topics = [ "classes", "state", "methods" ]
  e.points = 20
end

Exercise.find_or_create_by!(lesson: classes_lesson, position: 3) do |e|
  e.title = "Rectangle Class"
  e.title_ru = "Класс Rectangle"
  e.description = "Create a Rectangle class with area and perimeter calculations."
  e.description_ru = "Создайте класс Rectangle с вычислением площади и периметра."
  e.instructions = <<~MD
    Create a `Rectangle` class with:

    - `initialize(width, height)`
    - `width` and `height` reader attributes
    - `area` method returning width * height
    - `perimeter` method returning 2 * (width + height)
    - `square?` method returning true if width equals height
  MD
  e.instructions_ru = <<~MD
    Создайте класс `Rectangle` с:

    - `initialize(width, height)`
    - Атрибутами чтения `width` и `height`
    - Методом `area`, возвращающим width * height
    - Методом `perimeter`, возвращающим 2 * (width + height)
    - Методом `square?`, возвращающим true, если width равен height
  MD
  e.hints = [
    "Use attr_reader :width, :height",
    "Area = width * height",
    "Perimeter = 2 * (width + height)"
  ]
  e.hints_ru = [
    "Используйте attr_reader :width, :height",
    "Площадь = width * height",
    "Периметр = 2 * (width + height)"
  ]
  e.starter_code = <<~RUBY
    class Rectangle
      # Your code here
    end
  RUBY
  e.solution_code = <<~RUBY
    class Rectangle
      attr_reader :width, :height

      def initialize(width, height)
        @width = width
        @height = height
      end

      def area
        width * height
      end

      def perimeter
        2 * (width + height)
      end

      def square?
        width == height
      end
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe Rectangle do
      let(:rect) { Rectangle.new(4, 5) }
      let(:square) { Rectangle.new(3, 3) }

      it "has width and height" do
        expect(rect.width).to eq(4)
        expect(rect.height).to eq(5)
      end

      it "calculates area" do
        expect(rect.area).to eq(20)
      end

      it "calculates perimeter" do
        expect(rect.perimeter).to eq(18)
      end

      it "knows if it is a square" do
        expect(rect.square?).to be false
        expect(square.square?).to be true
      end
    end
  RUBY
  e.topics = [ "classes", "calculations", "predicates" ]
  e.points = 20
end

# Modules Lesson
modules_lesson = Lesson.find_or_create_by!(module_number: 3, position: 2) do |l|
  l.title = "Modules and Mixins"
  l.title_ru = "Модули и примеси"
  l.description = "Learn to use modules for namespacing and sharing behavior."
  l.description_ru = "Научитесь использовать модули для пространства имён и разделения поведения."
  l.difficulty = :intermediate
  l.ruby_version = "3.4"
end

Exercise.find_or_create_by!(lesson: modules_lesson, position: 1) do |e|
  e.title = "Greeting Module"
  e.title_ru = "Модуль приветствия"
  e.description = "Create a module with greeting methods to mix into classes."
  e.description_ru = "Создайте модуль с методами приветствия для подмешивания в классы."
  e.instructions = <<~MD
    Create a `Greetable` module with:

    - A `greet` method that returns "Hello, I'm \#{name}!"
    - Assumes the class has a `name` method

    Then create a `Person` class that:
    - Includes the `Greetable` module
    - Has a `name` attribute set in initialize
  MD
  e.instructions_ru = <<~MD
    Создайте модуль `Greetable` с:

    - Методом `greet`, который возвращает "Hello, I'm \#{name}!"
    - Предполагается, что класс имеет метод `name`

    Затем создайте класс `Person`, который:
    - Включает модуль `Greetable`
    - Имеет атрибут `name`, установленный в initialize
  MD
  e.hints = [
    "Define module with: module Greetable",
    "Use include Greetable in the class",
    "The module can call methods from the class"
  ]
  e.hints_ru = [
    "Определите модуль с помощью: module Greetable",
    "Используйте include Greetable в классе",
    "Модуль может вызывать методы из класса"
  ]
  e.starter_code = <<~RUBY
    module Greetable
      # Your code here
    end

    class Person
      # Your code here
    end
  RUBY
  e.solution_code = <<~RUBY
    module Greetable
      def greet
        "Hello, I'm \#{name}!"
      end
    end

    class Person
      include Greetable

      attr_reader :name

      def initialize(name)
        @name = name
      end
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe Person do
      let(:person) { Person.new("Alice") }

      it "has a name" do
        expect(person.name).to eq("Alice")
      end

      it "can greet" do
        expect(person.greet).to eq("Hello, I'm Alice!")
      end

      it "includes Greetable" do
        expect(Person.included_modules).to include(Greetable)
      end
    end
  RUBY
  e.topics = [ "modules", "mixins", "include" ]
  e.points = 20
end

Exercise.find_or_create_by!(lesson: modules_lesson, position: 2) do |e|
  e.title = "Comparable Module"
  e.title_ru = "Модуль Comparable"
  e.description = "Implement comparison using the Comparable module."
  e.description_ru = "Реализуйте сравнение с помощью модуля Comparable."
  e.instructions = <<~MD
    Create a `Box` class that:

    - Has a `volume` attribute (set in initialize)
    - Includes the `Comparable` module
    - Implements the `<=>` (spaceship) operator to compare by volume

    This will give you <, >, ==, <=, >= for free!
  MD
  e.instructions_ru = <<~MD
    Создайте класс `Box`, который:

    - Имеет атрибут `volume` (устанавливается в initialize)
    - Включает модуль `Comparable`
    - Реализует оператор `<=>` (spaceship) для сравнения по объёму

    Это даст вам <, >, ==, <=, >= бесплатно!
  MD
  e.hints = [
    "Include Comparable",
    "Implement def <=>(other)",
    "Return volume <=> other.volume"
  ]
  e.hints_ru = [
    "Включите Comparable",
    "Реализуйте def <=>(other)",
    "Верните volume <=> other.volume"
  ]
  e.starter_code = <<~RUBY
    class Box
      # Your code here
    end
  RUBY
  e.solution_code = <<~RUBY
    class Box
      include Comparable

      attr_reader :volume

      def initialize(volume)
        @volume = volume
      end

      def <=>(other)
        volume <=> other.volume
      end
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe Box do
      let(:small) { Box.new(10) }
      let(:medium) { Box.new(20) }
      let(:large) { Box.new(30) }

      it "compares with <" do
        expect(small < medium).to be true
      end

      it "compares with >" do
        expect(large > medium).to be true
      end

      it "compares with ==" do
        expect(Box.new(10) == Box.new(10)).to be true
      end

      it "can be sorted" do
        boxes = [large, small, medium]
        expect(boxes.sort.map(&:volume)).to eq([10, 20, 30])
      end
    end
  RUBY
  e.topics = [ "modules", "Comparable", "spaceship operator" ]
  e.points = 25
end

# Procs & Lambdas Lesson
procs_lesson = Lesson.find_or_create_by!(module_number: 3, position: 3) do |l|
  l.title = "Procs and Lambdas"
  l.title_ru = "Proc и Lambda"
  l.description = "Understand blocks, procs, and lambdas - Ruby's callable objects."
  l.description_ru = "Изучите блоки, proc и lambda — вызываемые объекты Ruby."
  l.difficulty = :intermediate
  l.ruby_version = "3.4"
end

Exercise.find_or_create_by!(lesson: procs_lesson, position: 1) do |e|
  e.title = "Create a Proc"
  e.title_ru = "Создание Proc"
  e.description = "Create and call a Proc object."
  e.description_ru = "Создайте и вызовите объект Proc."
  e.instructions = <<~MD
    Create a function `make_multiplier` that takes a number and returns
    a Proc that multiplies its argument by that number.

    Create a Proc with:
    ```ruby
    Proc.new { |x| x * 2 }
    # or
    proc { |x| x * 2 }
    # or
    ->(x) { x * 2 }  # This is actually a lambda
    ```

    Call a Proc with `.call(arg)` or `.(arg)` or `[arg]`.

    Example:
    ```ruby
    double = make_multiplier(2)
    double.call(5)  # => 10
    ```
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `make_multiplier`, которая принимает число и возвращает
    Proc, умножающий свой аргумент на это число.

    Создайте Proc с помощью:
    ```ruby
    Proc.new { |x| x * 2 }
    # или
    proc { |x| x * 2 }
    # или
    ->(x) { x * 2 }  # Это на самом деле lambda
    ```

    Вызовите Proc с помощью `.call(arg)`, `.(arg)` или `[arg]`.

    Пример:
    ```ruby
    double = make_multiplier(2)
    double.call(5)  # => 10
    ```
  MD
  e.hints = [
    "Return Proc.new { |x| x * n }",
    "The proc captures the variable n (closure)",
    "Procs are objects that wrap blocks"
  ]
  e.hints_ru = [
    "Верните Proc.new { |x| x * n }",
    "Proc захватывает переменную n (замыкание)",
    "Proc - это объекты, оборачивающие блоки"
  ]
  e.starter_code = <<~RUBY
    def make_multiplier(n)
      # Return a Proc that multiplies by n
    end
  RUBY
  e.solution_code = <<~RUBY
    def make_multiplier(n)
      Proc.new { |x| x * n }
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "make_multiplier" do
      it "creates a multiplier proc" do
        double = make_multiplier(2)
        expect(double.call(5)).to eq(10)
      end

      it "works with different multipliers" do
        triple = make_multiplier(3)
        expect(triple.call(4)).to eq(12)
      end

      it "captures the value (closure)" do
        times_ten = make_multiplier(10)
        expect(times_ten.call(7)).to eq(70)
      end
    end
  RUBY
  e.topics = [ "procs", "closures", "callable objects" ]
  e.points = 20
end

Exercise.find_or_create_by!(lesson: procs_lesson, position: 2) do |e|
  e.title = "Lambda vs Proc"
  e.title_ru = "Lambda против Proc"
  e.description = "Understand the differences between lambdas and procs."
  e.description_ru = "Изучите различия между lambda и proc."
  e.instructions = <<~MD
    Create two functions that demonstrate the key difference between
    procs and lambdas: **argument checking**.

    1. `strict_add` - uses a lambda (checks argument count)
    2. `lenient_add` - uses a proc (ignores extra arguments)

    Lambdas are created with:
    ```ruby
    ->(a, b) { a + b }
    # or
    lambda { |a, b| a + b }
    ```

    Both should add two numbers, but:
    - Lambda raises ArgumentError if wrong number of args
    - Proc ignores extra args or uses nil for missing
  MD
  e.instructions_ru = <<~MD
    Создайте две функции, демонстрирующие ключевое различие между
    proc и lambda: **проверка аргументов**.

    1. `strict_add` - использует lambda (проверяет количество аргументов)
    2. `lenient_add` - использует proc (игнорирует лишние аргументы)

    Lambda создаются с помощью:
    ```ruby
    ->(a, b) { a + b }
    # или
    lambda { |a, b| a + b }
    ```

    Обе должны складывать два числа, но:
    - Lambda вызывает ArgumentError при неверном количестве аргументов
    - Proc игнорирует лишние аргументы или использует nil для недостающих
  MD
  e.hints = [
    "Use ->(a, b) { a + b } for lambda",
    "Use Proc.new { |a, b| a + b } for proc",
    "Both return callable objects"
  ]
  e.hints_ru = [
    "Используйте ->(a, b) { a + b } для lambda",
    "Используйте Proc.new { |a, b| a + b } для proc",
    "Оба возвращают вызываемые объекты"
  ]
  e.starter_code = <<~RUBY
    def strict_add
      # Return a lambda that adds two numbers
    end

    def lenient_add
      # Return a proc that adds two numbers
    end
  RUBY
  e.solution_code = <<~RUBY
    def strict_add
      ->(a, b) { a + b }
    end

    def lenient_add
      Proc.new { |a, b| a.to_i + b.to_i }
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "Lambda vs Proc" do
      describe "strict_add (lambda)" do
        it "adds two numbers" do
          expect(strict_add.call(2, 3)).to eq(5)
        end

        it "raises error with wrong arg count" do
          expect { strict_add.call(1) }.to raise_error(ArgumentError)
        end

        it "is a lambda" do
          expect(strict_add.lambda?).to be true
        end
      end

      describe "lenient_add (proc)" do
        it "adds two numbers" do
          expect(lenient_add.call(2, 3)).to eq(5)
        end

        it "handles missing args" do
          expect(lenient_add.call(5)).to eq(5)  # nil.to_i = 0
        end

        it "is not a lambda" do
          expect(lenient_add.lambda?).to be false
        end
      end
    end
  RUBY
  e.topics = [ "procs", "lambdas", "argument checking" ]
  e.points = 25
end

Exercise.find_or_create_by!(lesson: procs_lesson, position: 3) do |e|
  e.title = "Block to Proc"
  e.title_ru = "Блок в Proc"
  e.description = "Convert blocks to procs and vice versa."
  e.description_ru = "Преобразуйте блоки в proc и обратно."
  e.instructions = <<~MD
    Create a function `apply_twice` that takes a value and a block,
    then applies the block twice to the value.

    Use `&block` to capture a block as a Proc parameter:
    ```ruby
    def my_method(&block)
      block.call(value)  # block is now a Proc
    end
    ```

    Example:
    ```ruby
    apply_twice(2) { |x| x * 3 }
    # First: 2 * 3 = 6
    # Second: 6 * 3 = 18
    # => 18
    ```
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `apply_twice`, которая принимает значение и блок,
    затем применяет блок дважды к значению.

    Используйте `&block` для захвата блока как параметра Proc:
    ```ruby
    def my_method(&block)
      block.call(value)  # block теперь Proc
    end
    ```

    Пример:
    ```ruby
    apply_twice(2) { |x| x * 3 }
    # Первый раз: 2 * 3 = 6
    # Второй раз: 6 * 3 = 18
    # => 18
    ```
  MD
  e.hints = [
    "Define as def apply_twice(value, &block)",
    "Call block.call(result) twice",
    "The & converts block to Proc"
  ]
  e.hints_ru = [
    "Определите как def apply_twice(value, &block)",
    "Вызовите block.call(result) дважды",
    "Символ & преобразует блок в Proc"
  ]
  e.starter_code = <<~RUBY
    def apply_twice(value, &block)
      # Apply the block twice
    end
  RUBY
  e.solution_code = <<~RUBY
    def apply_twice(value, &block)
      result = block.call(value)
      block.call(result)
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "apply_twice" do
      it "applies block twice" do
        result = apply_twice(2) { |x| x * 3 }
        expect(result).to eq(18)
      end

      it "works with addition" do
        result = apply_twice(5) { |x| x + 10 }
        expect(result).to eq(25)
      end

      it "works with strings" do
        result = apply_twice("a") { |s| s + s }
        expect(result).to eq("aaaa")
      end
    end
  RUBY
  e.topics = [ "blocks", "procs", "block to proc" ]
  e.points = 20
end

Exercise.find_or_create_by!(lesson: procs_lesson, position: 4) do |e|
  e.title = "Compose Functions"
  e.title_ru = "Композиция функций"
  e.description = "Combine multiple procs into one."
  e.description_ru = "Объедините несколько proc в один."
  e.instructions = <<~MD
    Create a function `compose` that takes two procs (f and g) and
    returns a new proc that applies g first, then f.

    Mathematical composition: (f ∘ g)(x) = f(g(x))

    Example:
    ```ruby
    add_one = ->(x) { x + 1 }
    double = ->(x) { x * 2 }

    composed = compose(add_one, double)
    composed.call(3)  # double(3) = 6, add_one(6) = 7
    # => 7
    ```
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `compose`, которая принимает два proc (f и g) и
    возвращает новый proc, применяющий сначала g, затем f.

    Математическая композиция: (f ∘ g)(x) = f(g(x))

    Пример:
    ```ruby
    add_one = ->(x) { x + 1 }
    double = ->(x) { x * 2 }

    composed = compose(add_one, double)
    composed.call(3)  # double(3) = 6, add_one(6) = 7
    # => 7
    ```
  MD
  e.hints = [
    "Return a new proc/lambda",
    "Inside, call g first, then f",
    "->(x) { f.call(g.call(x)) }"
  ]
  e.hints_ru = [
    "Верните новый proc/lambda",
    "Внутри вызовите сначала g, затем f",
    "->(x) { f.call(g.call(x)) }"
  ]
  e.starter_code = <<~RUBY
    def compose(f, g)
      # Return a proc that applies g then f
    end
  RUBY
  e.solution_code = <<~RUBY
    def compose(f, g)
      ->(x) { f.call(g.call(x)) }
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "compose" do
      let(:add_one) { ->(x) { x + 1 } }
      let(:double) { ->(x) { x * 2 } }
      let(:square) { ->(x) { x * x } }

      it "composes two functions" do
        composed = compose(add_one, double)
        expect(composed.call(3)).to eq(7)  # double(3)=6, +1=7
      end

      it "order matters" do
        f_then_g = compose(double, add_one)
        g_then_f = compose(add_one, double)
        expect(f_then_g.call(3)).to eq(8)  # (3+1)*2
        expect(g_then_f.call(3)).to eq(7)  # 3*2+1
      end

      it "works with multiple compositions" do
        triple = compose(compose(add_one, double), square)
        expect(triple.call(2)).to eq(9)  # 2²=4, *2=8, +1=9
      end
    end
  RUBY
  e.topics = [ "procs", "lambdas", "composition", "functional" ]
  e.points = 25
end

# Exception Handling Lesson
exceptions_lesson = Lesson.find_or_create_by!(module_number: 3, position: 4) do |l|
  l.title = "Exception Handling"
  l.title_ru = "Обработка исключений"
  l.description = "Learn to handle errors gracefully with begin/rescue/ensure."
  l.description_ru = "Научитесь корректно обрабатывать ошибки с помощью begin/rescue/ensure."
  l.difficulty = :intermediate
  l.ruby_version = "3.4"
end

Exercise.find_or_create_by!(lesson: exceptions_lesson, position: 1) do |e|
  e.title = "Basic Rescue"
  e.title_ru = "Базовый Rescue"
  e.description = "Catch and handle exceptions with rescue."
  e.description_ru = "Перехватите и обработайте исключения с помощью rescue."
  e.instructions = <<~MD
    Create a function `safe_divide` that divides two numbers.
    If division by zero occurs, return `nil` instead of raising an error.

    Use begin/rescue to catch exceptions:
    ```ruby
    begin
      # risky code
    rescue ZeroDivisionError
      # handle error
    end
    ```
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `safe_divide`, которая делит два числа.
    Если происходит деление на ноль, верните `nil` вместо вызова ошибки.

    Используйте begin/rescue для перехвата исключений:
    ```ruby
    begin
      # рискованный код
    rescue ZeroDivisionError
      # обработка ошибки
    end
    ```
  MD
  e.hints = [
    "Wrap the division in begin/rescue",
    "Catch ZeroDivisionError specifically",
    "Return nil in the rescue block"
  ]
  e.hints_ru = [
    "Оберните деление в begin/rescue",
    "Перехватите конкретно ZeroDivisionError",
    "Верните nil в блоке rescue"
  ]
  e.starter_code = <<~RUBY
    def safe_divide(a, b)
      # Divide a by b, return nil if division by zero
    end
  RUBY
  e.solution_code = <<~RUBY
    def safe_divide(a, b)
      begin
        a / b
      rescue ZeroDivisionError
        nil
      end
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "safe_divide" do
      it "divides normally" do
        expect(safe_divide(10, 2)).to eq(5)
      end

      it "returns nil for division by zero" do
        expect(safe_divide(10, 0)).to be_nil
      end

      it "handles negative numbers" do
        expect(safe_divide(-10, 2)).to eq(-5)
      end
    end
  RUBY
  e.topics = [ "exceptions", "rescue", "error handling" ]
  e.points = 15
end

Exercise.find_or_create_by!(lesson: exceptions_lesson, position: 2) do |e|
  e.title = "Multiple Rescue"
  e.title_ru = "Множественный Rescue"
  e.description = "Handle different exception types differently."
  e.description_ru = "Обработайте разные типы исключений по-разному."
  e.instructions = <<~MD
    Create a function `parse_number` that takes a string and returns
    a parsed integer. Handle these cases:

    - Valid number string: return the integer
    - Invalid format: return `:invalid_format`
    - Nil input: return `:no_input`

    Rescue multiple exception types:
    ```ruby
    begin
      # code
    rescue ArgumentError
      # handle one type
    rescue NoMethodError
      # handle another
    end
    ```
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `parse_number`, которая принимает строку и возвращает
    разобранное целое число. Обработайте следующие случаи:

    - Корректная числовая строка: верните целое число
    - Некорректный формат: верните `:invalid_format`
    - Ввод nil: верните `:no_input`

    Перехватывайте несколько типов исключений:
    ```ruby
    begin
      # код
    rescue ArgumentError
      # обработка одного типа
    rescue NoMethodError
      # обработка другого
    end
    ```
  MD
  e.hints = [
    "Use Integer(str) for strict parsing",
    "ArgumentError for invalid format",
    "NoMethodError when calling on nil"
  ]
  e.hints_ru = [
    "Используйте Integer(str) для строгого разбора",
    "ArgumentError для некорректного формата",
    "NoMethodError при вызове на nil"
  ]
  e.starter_code = <<~RUBY
    def parse_number(str)
      # Parse string to integer with error handling
    end
  RUBY
  e.solution_code = <<~RUBY
    def parse_number(str)
      Integer(str)
    rescue ArgumentError
      :invalid_format
    rescue TypeError, NoMethodError
      :no_input
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "parse_number" do
      it "parses valid numbers" do
        expect(parse_number("42")).to eq(42)
        expect(parse_number("-5")).to eq(-5)
      end

      it "returns :invalid_format for bad input" do
        expect(parse_number("abc")).to eq(:invalid_format)
        expect(parse_number("12.5")).to eq(:invalid_format)
      end

      it "returns :no_input for nil" do
        expect(parse_number(nil)).to eq(:no_input)
      end
    end
  RUBY
  e.topics = [ "exceptions", "multiple rescue", "error types" ]
  e.points = 20
end

Exercise.find_or_create_by!(lesson: exceptions_lesson, position: 3) do |e|
  e.title = "Ensure Block"
  e.title_ru = "Блок Ensure"
  e.description = "Use ensure for cleanup that always runs."
  e.description_ru = "Используйте ensure для очистки, которая выполняется всегда."
  e.instructions = <<~MD
    Create a function `with_counter` that:
    1. Takes a counter array (to track calls) and a block
    2. Adds `:started` to counter
    3. Yields to the block
    4. Adds `:finished` to counter (ALWAYS, even if error)

    Use `ensure` for code that must run:
    ```ruby
    begin
      yield
    ensure
      # always runs
    end
    ```
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `with_counter`, которая:
    1. Принимает массив-счётчик (для отслеживания вызовов) и блок
    2. Добавляет `:started` в счётчик
    3. Передаёт управление блоку (yield)
    4. Добавляет `:finished` в счётчик (ВСЕГДА, даже при ошибке)

    Используйте `ensure` для кода, который должен выполниться:
    ```ruby
    begin
      yield
    ensure
      # выполняется всегда
    end
    ```
  MD
  e.hints = [
    "Add :started before yield",
    "Add :finished in ensure block",
    "ensure runs even if error occurs"
  ]
  e.hints_ru = [
    "Добавьте :started перед yield",
    "Добавьте :finished в блоке ensure",
    "ensure выполняется даже при возникновении ошибки"
  ]
  e.starter_code = <<~RUBY
    def with_counter(counter)
      # Track :started, yield, track :finished (always)
    end
  RUBY
  e.solution_code = <<~RUBY
    def with_counter(counter)
      counter << :started
      yield
    ensure
      counter << :finished
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "with_counter" do
      it "tracks start and finish" do
        counter = []
        with_counter(counter) { "work" }
        expect(counter).to eq([:started, :finished])
      end

      it "finishes even with error" do
        counter = []
        begin
          with_counter(counter) { raise "oops" }
        rescue
        end
        expect(counter).to eq([:started, :finished])
      end
    end
  RUBY
  e.topics = [ "exceptions", "ensure", "cleanup" ]
  e.points = 20
end

Exercise.find_or_create_by!(lesson: exceptions_lesson, position: 4) do |e|
  e.title = "Raise Custom Error"
  e.title_ru = "Вызов пользовательской ошибки"
  e.description = "Create and raise your own exception class."
  e.description_ru = "Создайте и вызовите собственный класс исключения."
  e.instructions = <<~MD
    Create a custom exception class `ValidationError` that inherits
    from `StandardError`.

    Then create a function `validate_age` that:
    - Returns the age if between 0 and 150
    - Raises `ValidationError` with a message otherwise

    Define custom exceptions:
    ```ruby
    class MyError < StandardError; end

    raise MyError, "something went wrong"
    ```
  MD
  e.instructions_ru = <<~MD
    Создайте пользовательский класс исключения `ValidationError`,
    наследующий от `StandardError`.

    Затем создайте функцию `validate_age`, которая:
    - Возвращает возраст, если он между 0 и 150
    - Вызывает `ValidationError` с сообщением в противном случае

    Определение пользовательских исключений:
    ```ruby
    class MyError < StandardError; end

    raise MyError, "что-то пошло не так"
    ```
  MD
  e.hints = [
    "class ValidationError < StandardError; end",
    "raise ValidationError, 'message'",
    "Check age range with conditionals"
  ]
  e.hints_ru = [
    "class ValidationError < StandardError; end",
    "raise ValidationError, 'сообщение'",
    "Проверьте диапазон возраста с помощью условий"
  ]
  e.starter_code = <<~RUBY
    # Define ValidationError class

    def validate_age(age)
      # Return age if valid, raise ValidationError if not
    end
  RUBY
  e.solution_code = <<~RUBY
    class ValidationError < StandardError; end

    def validate_age(age)
      raise ValidationError, "Age must be between 0 and 150" unless (0..150).include?(age)
      age
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "validate_age" do
      it "returns valid ages" do
        expect(validate_age(25)).to eq(25)
        expect(validate_age(0)).to eq(0)
        expect(validate_age(150)).to eq(150)
      end

      it "raises ValidationError for negative" do
        expect { validate_age(-1) }.to raise_error(ValidationError)
      end

      it "raises ValidationError for too high" do
        expect { validate_age(151) }.to raise_error(ValidationError)
      end

      it "ValidationError inherits from StandardError" do
        expect(ValidationError.superclass).to eq(StandardError)
      end
    end
  RUBY
  e.topics = [ "exceptions", "custom errors", "raise" ]
  e.points = 25
end

# =============================================================================
# MODULE 4: Ruby 3.4 Features
# =============================================================================

# It Parameter Lesson
it_lesson = Lesson.find_or_create_by!(module_number: 4, position: 1) do |l|
  l.title = "The 'it' Parameter"
  l.title_ru = "Параметр 'it'"
  l.description = "Learn about Ruby 3.4's new 'it' keyword for single-parameter blocks."
  l.description_ru = "Изучите новое ключевое слово 'it' в Ruby 3.4 для блоков с одним параметром."
  l.difficulty = :modern
  l.ruby_version = "3.4"
end

Exercise.find_or_create_by!(lesson: it_lesson, position: 1) do |e|
  e.title = "Using 'it' in map"
  e.title_ru = "Использование 'it' в map"
  e.description = "Refactor code to use the new 'it' parameter syntax."
  e.description_ru = "Перепишите код, используя новый синтаксис параметра 'it'."
  e.instructions = <<~MD
    Ruby 3.4 introduced `it` as a shorthand for single-parameter blocks.

    Instead of:
    ```ruby
    [1, 2, 3].map { |n| n * 2 }
    ```

    You can write:
    ```ruby
    [1, 2, 3].map { it * 2 }
    ```

    Create a function `double_all` that doubles each number using `it`.
  MD
  e.instructions_ru = <<~MD
    Ruby 3.4 ввёл `it` как сокращение для блоков с одним параметром.

    Вместо:
    ```ruby
    [1, 2, 3].map { |n| n * 2 }
    ```

    Можно написать:
    ```ruby
    [1, 2, 3].map { it * 2 }
    ```

    Создайте функцию `double_all`, которая удваивает каждое число, используя `it`.
  MD
  e.hints = [
    "Use .map { it * 2 }",
    "'it' refers to the block parameter automatically",
    "This only works in Ruby 3.4+"
  ]
  e.hints_ru = [
    "Используйте .map { it * 2 }",
    "'it' автоматически ссылается на параметр блока",
    "Это работает только в Ruby 3.4+"
  ]
  e.starter_code = <<~RUBY
    def double_all(numbers)
      # Use the 'it' keyword instead of |n|
      numbers.map { |n| n * 2 }
    end
  RUBY
  e.solution_code = <<~RUBY
    def double_all(numbers)
      numbers.map { it * 2 }
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "double_all with 'it'" do
      it "doubles each number" do
        expect(double_all([1, 2, 3])).to eq([2, 4, 6])
      end

      it "handles empty array" do
        expect(double_all([])).to eq([])
      end

      it "handles negative numbers" do
        expect(double_all([-1, -2])).to eq([-2, -4])
      end
    end
  RUBY
  e.topics = [ "ruby 3.4", "it parameter", "blocks", "map" ]
  e.points = 20
end

Exercise.find_or_create_by!(lesson: it_lesson, position: 2) do |e|
  e.title = "Chaining with 'it'"
  e.title_ru = "Цепочка с 'it'"
  e.description = "Use 'it' for method chaining in blocks."
  e.description_ru = "Используйте 'it' для цепочки методов в блоках."
  e.instructions = <<~MD
    Use `it` to call methods on the block parameter.

    Create a function `upcase_all` that converts each string to uppercase.

    Instead of:
    ```ruby
    words.map { |w| w.upcase }
    ```

    Use:
    ```ruby
    words.map { it.upcase }
    ```
  MD
  e.instructions_ru = <<~MD
    Используйте `it` для вызова методов на параметре блока.

    Создайте функцию `upcase_all`, которая преобразует каждую строку в верхний регистр.

    Вместо:
    ```ruby
    words.map { |w| w.upcase }
    ```

    Используйте:
    ```ruby
    words.map { it.upcase }
    ```
  MD
  e.hints = [
    "Use .map { it.upcase }",
    "'it' is the block parameter",
    "You can call any method on 'it'"
  ]
  e.hints_ru = [
    "Используйте .map { it.upcase }",
    "'it' — это параметр блока",
    "Вы можете вызывать любой метод на 'it'"
  ]
  e.starter_code = <<~RUBY
    def upcase_all(words)
      # Use 'it' to call upcase
      words.map { |w| w.upcase }
    end
  RUBY
  e.solution_code = <<~RUBY
    def upcase_all(words)
      words.map { it.upcase }
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "upcase_all with 'it'" do
      it "upcases each word" do
        expect(upcase_all(["hello", "world"])).to eq(["HELLO", "WORLD"])
      end

      it "handles mixed case" do
        expect(upcase_all(["Ruby", "RAILS"])).to eq(["RUBY", "RAILS"])
      end
    end
  RUBY
  e.topics = [ "ruby 3.4", "it parameter", "method chaining" ]
  e.points = 15
end

Exercise.find_or_create_by!(lesson: it_lesson, position: 3) do |e|
  e.title = "Filter with 'it'"
  e.title_ru = "Фильтр с 'it'"
  e.description = "Use 'it' with select and reject methods."
  e.description_ru = "Используйте 'it' с методами select и reject."
  e.instructions = <<~MD
    Use `it` with filtering methods like `select`.

    Create a function `select_long_words` that returns words
    with more than 5 characters.

    Use `it.length > 5` in your select block.
  MD
  e.instructions_ru = <<~MD
    Используйте `it` с методами фильтрации, такими как `select`.

    Создайте функцию `select_long_words`, которая возвращает слова
    длиннее 5 символов.

    Используйте `it.length > 5` в вашем блоке select.
  MD
  e.hints = [
    "Use .select { it.length > 5 }",
    "'it' works with any block method",
    "select keeps elements where block is true"
  ]
  e.hints_ru = [
    "Используйте .select { it.length > 5 }",
    "'it' работает с любым методом, принимающим блок",
    "select оставляет элементы, для которых блок возвращает true"
  ]
  e.starter_code = <<~RUBY
    def select_long_words(words)
      # Use 'it' with select
    end
  RUBY
  e.solution_code = <<~RUBY
    def select_long_words(words)
      words.select { it.length > 5 }
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "select_long_words with 'it'" do
      it "selects words longer than 5 chars" do
        result = select_long_words(["hi", "hello", "programming", "ruby"])
        expect(result).to eq(["programming"])
      end

      it "handles empty array" do
        expect(select_long_words([])).to eq([])
      end

      it "handles all short words" do
        expect(select_long_words(["a", "bb", "ccc"])).to eq([])
      end
    end
  RUBY
  e.topics = [ "ruby 3.4", "it parameter", "select", "filter" ]
  e.points = 15
end

# Pattern Matching Lesson
pattern_lesson = Lesson.find_or_create_by!(module_number: 4, position: 2) do |l|
  l.title = "Pattern Matching"
  l.title_ru = "Сопоставление с образцом"
  l.description = "Learn Ruby's powerful pattern matching syntax for destructuring data."
  l.description_ru = "Изучите мощный синтаксис сопоставления с образцом Ruby для деструктуризации данных."
  l.difficulty = :modern
  l.ruby_version = "3.4"
end

Exercise.find_or_create_by!(lesson: pattern_lesson, position: 1) do |e|
  e.title = "Array Destructuring"
  e.title_ru = "Деструктуризация массива"
  e.description = "Use pattern matching to extract values from arrays."
  e.description_ru = "Используйте сопоставление с образцом для извлечения значений из массивов."
  e.instructions = <<~MD
    Create a function `first_two` that uses pattern matching to extract
    the first two elements from an array.

    Use the `in` pattern matching syntax:
    ```ruby
    case array
    in [first, second, *rest]
      # use first and second
    end
    ```

    Return an array with just the first two elements.
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `first_two`, которая использует сопоставление с образцом
    для извлечения первых двух элементов из массива.

    Используйте синтаксис сопоставления с `in`:
    ```ruby
    case array
    in [first, second, *rest]
      # используйте first и second
    end
    ```

    Верните массив только с первыми двумя элементами.
  MD
  e.hints = [
    "Use case/in for pattern matching",
    "Use [a, b, *] to match first two and ignore rest",
    "Return [a, b]"
  ]
  e.hints_ru = [
    "Используйте case/in для сопоставления с образцом",
    "Используйте [a, b, *] для соответствия первым двум и игнорирования остальных",
    "Верните [a, b]"
  ]
  e.starter_code = <<~RUBY
    def first_two(array)
      # Use pattern matching to extract first two elements
    end
  RUBY
  e.solution_code = <<~RUBY
    def first_two(array)
      case array
      in [a, b, *]
        [a, b]
      in [a]
        [a, nil]
      in []
        [nil, nil]
      end
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "first_two" do
      it "extracts first two from longer array" do
        expect(first_two([1, 2, 3, 4])).to eq([1, 2])
      end

      it "works with exactly two elements" do
        expect(first_two([5, 6])).to eq([5, 6])
      end

      it "handles single element" do
        expect(first_two([1])).to eq([1, nil])
      end

      it "handles empty array" do
        expect(first_two([])).to eq([nil, nil])
      end
    end
  RUBY
  e.topics = [ "ruby 3.4", "pattern matching", "destructuring" ]
  e.points = 25
end

Exercise.find_or_create_by!(lesson: pattern_lesson, position: 2) do |e|
  e.title = "Hash Pattern Matching"
  e.title_ru = "Сопоставление хешей"
  e.description = "Extract values from hashes using pattern matching."
  e.description_ru = "Извлекайте значения из хешей с помощью сопоставления с образцом."
  e.instructions = <<~MD
    Create a function `greet_user` that takes a user hash and returns
    a greeting based on the user's role.

    Use hash pattern matching:
    ```ruby
    case user
    in { name:, role: "admin" }
      "Welcome back, Admin \#{name}!"
    in { name: }
      "Hello, \#{name}!"
    end
    ```
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `greet_user`, которая принимает хеш пользователя
    и возвращает приветствие в зависимости от роли.

    Используйте сопоставление хешей:
    ```ruby
    case user
    in { name:, role: "admin" }
      "Welcome back, Admin \#{name}!"
    in { name: }
      "Hello, \#{name}!"
    end
    ```
  MD
  e.hints = [
    "Match hash keys directly: { name:, role: }",
    "Can match specific values: role: \"admin\"",
    "Matched keys become local variables"
  ]
  e.hints_ru = [
    "Сопоставляйте ключи хеша напрямую: { name:, role: }",
    "Можно сопоставлять конкретные значения: role: \"admin\"",
    "Сопоставленные ключи становятся локальными переменными"
  ]
  e.starter_code = <<~RUBY
    def greet_user(user)
      # Use pattern matching on the user hash
    end
  RUBY
  e.solution_code = <<~RUBY
    def greet_user(user)
      case user
      in { name:, role: "admin" }
        "Welcome back, Admin \#{name}!"
      in { name:, role: "guest" }
        "Welcome, Guest \#{name}!"
      in { name: }
        "Hello, \#{name}!"
      end
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "greet_user" do
      it "greets admin specially" do
        expect(greet_user({ name: "Alice", role: "admin" })).to eq("Welcome back, Admin Alice!")
      end

      it "greets guest" do
        expect(greet_user({ name: "Bob", role: "guest" })).to eq("Welcome, Guest Bob!")
      end

      it "greets regular user" do
        expect(greet_user({ name: "Charlie" })).to eq("Hello, Charlie!")
      end
    end
  RUBY
  e.topics = [ "ruby 3.4", "pattern matching", "hashes" ]
  e.points = 25
end

Exercise.find_or_create_by!(lesson: pattern_lesson, position: 3) do |e|
  e.title = "Guard Clauses in Patterns"
  e.title_ru = "Охранные условия"
  e.description = "Add conditions to pattern matching with guard clauses."
  e.description_ru = "Добавьте условия к сопоставлению с образцом с помощью охранных условий."
  e.instructions = <<~MD
    Create a function `describe_number` that uses pattern matching with guards.

    Return:
    - "zero" for 0
    - "positive" for numbers > 0
    - "negative" for numbers < 0

    Use guard clauses with `if`:
    ```ruby
    case n
    in x if x > 0
      "positive"
    end
    ```
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `describe_number`, которая использует сопоставление с охранными условиями.

    Верните:
    - "zero" для 0
    - "positive" для чисел > 0
    - "negative" для чисел < 0

    Используйте охранные условия с `if`:
    ```ruby
    case n
    in x if x > 0
      "positive"
    end
    ```
  MD
  e.hints = [
    "Use 'in x if condition' for guards",
    "The matched value is bound to x",
    "Handle each case: 0, positive, negative"
  ]
  e.hints_ru = [
    "Используйте 'in x if condition' для охранных условий",
    "Сопоставленное значение связывается с x",
    "Обработайте каждый случай: 0, положительное, отрицательное"
  ]
  e.starter_code = <<~RUBY
    def describe_number(n)
      # Use pattern matching with guards
    end
  RUBY
  e.solution_code = <<~RUBY
    def describe_number(n)
      case n
      in 0
        "zero"
      in x if x > 0
        "positive"
      in x if x < 0
        "negative"
      end
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "describe_number" do
      it "returns zero for 0" do
        expect(describe_number(0)).to eq("zero")
      end

      it "returns positive for positive numbers" do
        expect(describe_number(5)).to eq("positive")
        expect(describe_number(100)).to eq("positive")
      end

      it "returns negative for negative numbers" do
        expect(describe_number(-3)).to eq("negative")
        expect(describe_number(-100)).to eq("negative")
      end
    end
  RUBY
  e.topics = [ "ruby 3.4", "pattern matching", "guards" ]
  e.points = 20
end

Exercise.find_or_create_by!(lesson: pattern_lesson, position: 4) do |e|
  e.title = "Pattern Match with Types"
  e.title_ru = "Сопоставление с типами"
  e.description = "Match different types and structures with pattern matching."
  e.description_ru = "Сопоставляйте разные типы и структуры с помощью сопоставления с образцом."
  e.instructions = <<~MD
    Create a function `describe_value` that describes different types of values
    using pattern matching.

    Return:
    - "empty array" for `[]`
    - "single: X" for array with one element (where X is the element)
    - "pair: X, Y" for array with exactly two elements
    - "many: N elements" for arrays with more than 2 elements
    - "number: X" for integers
    - "text: X" for strings
    - "unknown" for anything else

    Use type checking in patterns:
    ```ruby
    case value
    in Integer => n
      "number: \#{n}"
    in [a, b]
      "pair"
    end
    ```
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `describe_value`, которая описывает разные типы значений
    с помощью сопоставления с образцом.

    Верните:
    - "empty array" для `[]`
    - "single: X" для массива с одним элементом (где X - элемент)
    - "pair: X, Y" для массива ровно с двумя элементами
    - "many: N elements" для массивов с более чем 2 элементами
    - "number: X" для целых чисел
    - "text: X" для строк
    - "unknown" для всего остального

    Используйте проверку типов в образцах:
    ```ruby
    case value
    in Integer => n
      "number: \#{n}"
    in [a, b]
      "pair"
    end
    ```
  MD
  e.hints = [
    "Use Integer => n to match and bind integers",
    "Use String => s for strings",
    "Use [*rest] to capture remaining elements"
  ]
  e.hints_ru = [
    "Используйте Integer => n для сопоставления и связывания целых чисел",
    "Используйте String => s для строк",
    "Используйте [*rest] для захвата оставшихся элементов"
  ]
  e.starter_code = <<~RUBY
    def describe_value(value)
      # Use pattern matching to handle different types
    end
  RUBY
  e.solution_code = <<~RUBY
    def describe_value(value)
      case value
      in []
        "empty array"
      in [x]
        "single: \#{x}"
      in [x, y]
        "pair: \#{x}, \#{y}"
      in [*, *] => arr if arr.length > 2
        "many: \#{arr.length} elements"
      in Integer => n
        "number: \#{n}"
      in String => s
        "text: \#{s}"
      else
        "unknown"
      end
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "describe_value" do
      it "handles empty array" do
        expect(describe_value([])).to eq("empty array")
      end

      it "handles single element array" do
        expect(describe_value([42])).to eq("single: 42")
      end

      it "handles pair" do
        expect(describe_value([1, 2])).to eq("pair: 1, 2")
      end

      it "handles many elements" do
        expect(describe_value([1, 2, 3, 4])).to eq("many: 4 elements")
      end

      it "handles integers" do
        expect(describe_value(42)).to eq("number: 42")
      end

      it "handles strings" do
        expect(describe_value("hello")).to eq("text: hello")
      end

      it "handles unknown types" do
        expect(describe_value(3.14)).to eq("unknown")
      end
    end
  RUBY
  e.topics = [ "ruby 3.4", "pattern matching", "types", "guards" ]
  e.points = 30
end

# Data Classes Lesson
data_lesson = Lesson.find_or_create_by!(module_number: 4, position: 3) do |l|
  l.title = "Data Classes"
  l.title_ru = "Data-классы"
  l.description = "Learn about Ruby 3.2+'s Data class for immutable value objects."
  l.description_ru = "Изучите класс Data из Ruby 3.2+ для создания неизменяемых объектов-значений."
  l.difficulty = :modern
  l.ruby_version = "3.4"
end

Exercise.find_or_create_by!(lesson: data_lesson, position: 1) do |e|
  e.title = "Create a Point Data Class"
  e.title_ru = "Создание Data-класса Point"
  e.description = "Use Data.define to create an immutable Point class."
  e.description_ru = "Используйте Data.define для создания неизменяемого класса Point."
  e.instructions = <<~MD
    Create a `Point` data class with `x` and `y` attributes.

    Data classes are created using:
    ```ruby
    Point = Data.define(:x, :y)
    ```

    Data classes are:
    - Immutable (can't change values after creation)
    - Have automatic equality based on values
    - Have a nice inspect/to_s output
  MD
  e.instructions_ru = <<~MD
    Создайте data-класс `Point` с атрибутами `x` и `y`.

    Data-классы создаются с помощью:
    ```ruby
    Point = Data.define(:x, :y)
    ```

    Data-классы:
    - Неизменяемые (нельзя изменить значения после создания)
    - Имеют автоматическое сравнение по значениям
    - Имеют красивый вывод inspect/to_s
  MD
  e.hints = [
    "Use Point = Data.define(:x, :y)",
    "Create with Point.new(x: 1, y: 2) or Point[1, 2]",
    "Access with point.x and point.y"
  ]
  e.hints_ru = [
    "Используйте Point = Data.define(:x, :y)",
    "Создайте с Point.new(x: 1, y: 2) или Point[1, 2]",
    "Доступ через point.x и point.y"
  ]
  e.starter_code = <<~RUBY
    # Define Point as a Data class
  RUBY
  e.solution_code = <<~RUBY
    Point = Data.define(:x, :y)
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "Point Data class" do
      it "creates a point with x and y" do
        point = Point.new(x: 3, y: 4)
        expect(point.x).to eq(3)
        expect(point.y).to eq(4)
      end

      it "can be created with positional args" do
        point = Point[1, 2]
        expect(point.x).to eq(1)
        expect(point.y).to eq(2)
      end

      it "has value equality" do
        expect(Point[1, 2]).to eq(Point[1, 2])
      end

      it "is frozen (immutable)" do
        point = Point[0, 0]
        expect(point.frozen?).to be true
      end
    end
  RUBY
  e.topics = [ "ruby 3.2+", "Data class", "immutable" ]
  e.points = 20
end

Exercise.find_or_create_by!(lesson: data_lesson, position: 2) do |e|
  e.title = "Data Class with Methods"
  e.title_ru = "Data-класс с методами"
  e.description = "Add methods to a Data class."
  e.description_ru = "Добавьте методы в Data-класс."
  e.instructions = <<~MD
    Create a `Circle` data class with a `radius` attribute and add methods:

    - `diameter` - returns radius * 2
    - `area` - returns Math::PI * radius ** 2

    You can add methods to Data classes by reopening or using a block:
    ```ruby
    Circle = Data.define(:radius) do
      def diameter
        radius * 2
      end
    end
    ```
  MD
  e.instructions_ru = <<~MD
    Создайте data-класс `Circle` с атрибутом `radius` и добавьте методы:

    - `diameter` - возвращает radius * 2
    - `area` - возвращает Math::PI * radius ** 2

    Вы можете добавить методы в Data-класс, используя блок:
    ```ruby
    Circle = Data.define(:radius) do
      def diameter
        radius * 2
      end
    end
    ```
  MD
  e.hints = [
    "Use Data.define(:radius) do ... end",
    "Define methods inside the block",
    "Use Math::PI for pi"
  ]
  e.hints_ru = [
    "Используйте Data.define(:radius) do ... end",
    "Определите методы внутри блока",
    "Используйте Math::PI для числа пи"
  ]
  e.starter_code = <<~RUBY
    # Define Circle with radius and add diameter and area methods
  RUBY
  e.solution_code = <<~RUBY
    Circle = Data.define(:radius) do
      def diameter
        radius * 2
      end

      def area
        Math::PI * radius ** 2
      end
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "Circle Data class" do
      let(:circle) { Circle.new(radius: 5) }

      it "has a radius" do
        expect(circle.radius).to eq(5)
      end

      it "calculates diameter" do
        expect(circle.diameter).to eq(10)
      end

      it "calculates area" do
        expect(circle.area).to be_within(0.01).of(78.54)
      end
    end
  RUBY
  e.topics = [ "ruby 3.2+", "Data class", "methods" ]
  e.points = 25
end

Exercise.find_or_create_by!(lesson: data_lesson, position: 3) do |e|
  e.title = "Data Class with Derived Values"
  e.title_ru = "Data-класс с вычисляемыми значениями"
  e.description = "Create a data class that calculates derived values."
  e.description_ru = "Создайте data-класс с вычисляемыми значениями."
  e.instructions = <<~MD
    Create a `Person` data class with `first_name` and `last_name` attributes.

    Add a `full_name` method that returns "\#{first_name} \#{last_name}".

    Also add an `initials` method that returns the first letter of each name.
    Example: "John Doe" -> "JD"
  MD
  e.instructions_ru = <<~MD
    Создайте data-класс `Person` с атрибутами `first_name` и `last_name`.

    Добавьте метод `full_name`, который возвращает "\#{first_name} \#{last_name}".

    Также добавьте метод `initials`, который возвращает первую букву каждого имени.
    Пример: "John Doe" -> "JD"
  MD
  e.hints = [
    "Use Data.define(:first_name, :last_name)",
    "full_name concatenates with space",
    "initials: first_name[0] + last_name[0]"
  ]
  e.hints_ru = [
    "Используйте Data.define(:first_name, :last_name)",
    "full_name объединяет через пробел",
    "initials: first_name[0] + last_name[0]"
  ]
  e.starter_code = <<~RUBY
    # Define Person with full_name and initials methods
  RUBY
  e.solution_code = <<~RUBY
    Person = Data.define(:first_name, :last_name) do
      def full_name
        "\#{first_name} \#{last_name}"
      end

      def initials
        "\#{first_name[0]}\#{last_name[0]}"
      end
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "Person Data class" do
      let(:person) { Person.new(first_name: "John", last_name: "Doe") }

      it "has first and last name" do
        expect(person.first_name).to eq("John")
        expect(person.last_name).to eq("Doe")
      end

      it "returns full name" do
        expect(person.full_name).to eq("John Doe")
      end

      it "returns initials" do
        expect(person.initials).to eq("JD")
      end
    end
  RUBY
  e.topics = [ "ruby 3.2+", "Data class", "derived values" ]
  e.points = 20
end

# Advanced Ruby Lesson
advanced_lesson = Lesson.find_or_create_by!(module_number: 4, position: 4) do |l|
  l.title = "Advanced Ruby"
  l.title_ru = "Продвинутый Ruby"
  l.description = "Explore advanced Ruby features: Set, lazy enumerators, and more."
  l.description_ru = "Изучите продвинутые возможности Ruby: Set, ленивые перечислители и многое другое."
  l.difficulty = :advanced
  l.ruby_version = "3.4"
end

Exercise.find_or_create_by!(lesson: advanced_lesson, position: 1) do |e|
  e.title = "Using Set"
  e.title_ru = "Использование Set"
  e.description = "Use Set for unique collections with fast lookups."
  e.description_ru = "Используйте Set для уникальных коллекций с быстрым поиском."
  e.instructions = <<~MD
    Create a function `unique_words` that takes a sentence and returns
    a Set of unique words (lowercase).

    Set is like an Array but:
    - Only stores unique elements
    - Has O(1) lookup time
    - No guaranteed order

    ```ruby
    require 'set'

    set = Set.new([1, 2, 2, 3])  # => #<Set: {1, 2, 3}>
    set.include?(2)              # => true (fast!)
    ```
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `unique_words`, которая принимает предложение и возвращает
    Set уникальных слов (в нижнем регистре).

    Set похож на Array, но:
    - Хранит только уникальные элементы
    - Имеет время поиска O(1)
    - Порядок не гарантирован

    ```ruby
    require 'set'

    set = Set.new([1, 2, 2, 3])  # => #<Set: {1, 2, 3}>
    set.include?(2)              # => true (быстро!)
    ```
  MD
  e.hints = [
    "require 'set' at the top",
    "Split sentence, downcase, convert to Set",
    "Set.new(array) removes duplicates"
  ]
  e.hints_ru = [
    "require 'set' в начале файла",
    "Разделите предложение, приведите к нижнему регистру, преобразуйте в Set",
    "Set.new(array) удаляет дубликаты"
  ]
  e.starter_code = <<~RUBY
    require 'set'

    def unique_words(sentence)
      # Return a Set of unique lowercase words
    end
  RUBY
  e.solution_code = <<~RUBY
    require 'set'

    def unique_words(sentence)
      Set.new(sentence.downcase.split)
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "unique_words" do
      it "returns unique words as a Set" do
        result = unique_words("Hello hello HELLO world")
        expect(result).to be_a(Set)
        expect(result).to eq(Set.new(["hello", "world"]))
      end

      it "handles empty string" do
        expect(unique_words("")).to eq(Set.new)
      end

      it "handles single word" do
        expect(unique_words("Ruby")).to eq(Set.new(["ruby"]))
      end
    end
  RUBY
  e.topics = [ "set", "collections", "unique elements" ]
  e.points = 20
end

Exercise.find_or_create_by!(lesson: advanced_lesson, position: 2) do |e|
  e.title = "Hash Transform"
  e.title_ru = "Трансформация Hash"
  e.description = "Transform hash keys and values with dedicated methods."
  e.description_ru = "Преобразуйте ключи и значения хеша с помощью специальных методов."
  e.instructions = <<~MD
    Create a function `normalize_user` that takes a user hash and:
    1. Converts all keys to symbols (using `transform_keys`)
    2. Strips whitespace from all string values (using `transform_values`)

    Hash transformation methods:
    ```ruby
    hash.transform_keys { |k| k.to_sym }
    hash.transform_values { |v| v.strip }
    ```

    Example:
    ```ruby
    normalize_user({ "name" => " Alice ", "email" => " a@b.com " })
    # => { name: "Alice", email: "a@b.com" }
    ```
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `normalize_user`, которая принимает хеш пользователя и:
    1. Преобразует все ключи в символы (используя `transform_keys`)
    2. Удаляет пробелы из всех строковых значений (используя `transform_values`)

    Методы трансформации хеша:
    ```ruby
    hash.transform_keys { |k| k.to_sym }
    hash.transform_values { |v| v.strip }
    ```

    Пример:
    ```ruby
    normalize_user({ "name" => " Alice ", "email" => " a@b.com " })
    # => { name: "Alice", email: "a@b.com" }
    ```
  MD
  e.hints = [
    "Chain transform_keys and transform_values",
    "Use .to_sym to convert string keys to symbols",
    "Use .strip for strings, handle non-strings"
  ]
  e.hints_ru = [
    "Соедините в цепочку transform_keys и transform_values",
    "Используйте .to_sym для преобразования строковых ключей в символы",
    "Используйте .strip для строк, обрабатывайте не-строки"
  ]
  e.starter_code = <<~RUBY
    def normalize_user(user)
      # Transform keys to symbols, strip string values
    end
  RUBY
  e.solution_code = <<~RUBY
    def normalize_user(user)
      user
        .transform_keys(&:to_sym)
        .transform_values { |v| v.is_a?(String) ? v.strip : v }
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "normalize_user" do
      it "converts keys to symbols and strips values" do
        input = { "name" => " Alice ", "email" => " a@b.com " }
        result = normalize_user(input)
        expect(result).to eq({ name: "Alice", email: "a@b.com" })
      end

      it "handles non-string values" do
        input = { "name" => " Bob ", "age" => 25 }
        result = normalize_user(input)
        expect(result).to eq({ name: "Bob", age: 25 })
      end

      it "handles empty hash" do
        expect(normalize_user({})).to eq({})
      end
    end
  RUBY
  e.topics = [ "hashes", "transform_keys", "transform_values" ]
  e.points = 20
end

Exercise.find_or_create_by!(lesson: advanced_lesson, position: 3) do |e|
  e.title = "Deep Dig"
  e.title_ru = "Глубокий Dig"
  e.description = "Safely access nested hash values with dig."
  e.description_ru = "Безопасно обращайтесь к вложенным значениям хеша с помощью dig."
  e.instructions = <<~MD
    Create a function `get_city` that extracts the city from a nested
    user hash structure. Return `nil` if any key is missing.

    Use `dig` for safe nested access:
    ```ruby
    hash = { user: { address: { city: "NYC" } } }
    hash.dig(:user, :address, :city)  # => "NYC"
    hash.dig(:user, :phone, :number)  # => nil (no error!)
    ```

    Expected structure:
    ```ruby
    { user: { address: { city: "..." } } }
    ```
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `get_city`, которая извлекает город из вложенной
    структуры хеша пользователя. Верните `nil`, если какой-либо ключ отсутствует.

    Используйте `dig` для безопасного доступа к вложенным данным:
    ```ruby
    hash = { user: { address: { city: "NYC" } } }
    hash.dig(:user, :address, :city)  # => "NYC"
    hash.dig(:user, :phone, :number)  # => nil (без ошибки!)
    ```

    Ожидаемая структура:
    ```ruby
    { user: { address: { city: "..." } } }
    ```
  MD
  e.hints = [
    "Use .dig(:user, :address, :city)",
    "dig returns nil if any key is missing",
    "No need for nil checks or rescue"
  ]
  e.hints_ru = [
    "Используйте .dig(:user, :address, :city)",
    "dig возвращает nil, если какой-либо ключ отсутствует",
    "Не нужны проверки на nil или rescue"
  ]
  e.starter_code = <<~RUBY
    def get_city(data)
      # Safely extract city from nested hash
    end
  RUBY
  e.solution_code = <<~RUBY
    def get_city(data)
      data.dig(:user, :address, :city)
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "get_city" do
      it "extracts city from nested hash" do
        data = { user: { address: { city: "Tokyo" } } }
        expect(get_city(data)).to eq("Tokyo")
      end

      it "returns nil for missing address" do
        data = { user: { name: "Alice" } }
        expect(get_city(data)).to be_nil
      end

      it "returns nil for missing user" do
        data = { other: "data" }
        expect(get_city(data)).to be_nil
      end

      it "returns nil for empty hash" do
        expect(get_city({})).to be_nil
      end
    end
  RUBY
  e.topics = [ "hashes", "dig", "nested access" ]
  e.points = 15
end

Exercise.find_or_create_by!(lesson: advanced_lesson, position: 4) do |e|
  e.title = "Lazy Enumeration"
  e.title_ru = "Ленивое перечисление"
  e.description = "Process large sequences efficiently with lazy evaluation."
  e.description_ru = "Эффективно обрабатывайте большие последовательности с помощью ленивых вычислений."
  e.instructions = <<~MD
    Create a function `first_n_primes` that returns the first N prime numbers.

    Use lazy enumerators to avoid computing unnecessary values:
    ```ruby
    (1..).lazy                    # Infinite sequence
      .select { |n| condition }   # Filter lazily
      .take(5)                    # Take only 5
      .to_a                       # Convert to array
    ```

    The `(1..)` creates an infinite range. Without `lazy`, this would
    run forever! With `lazy`, only the needed values are computed.

    A prime number is greater than 1 and divisible only by 1 and itself.
  MD
  e.instructions_ru = <<~MD
    Создайте функцию `first_n_primes`, которая возвращает первые N простых чисел.

    Используйте ленивые перечислители, чтобы не вычислять лишние значения:
    ```ruby
    (1..).lazy                    # Бесконечная последовательность
      .select { |n| condition }   # Фильтруем лениво
      .take(5)                    # Берём только 5
      .to_a                       # Преобразуем в массив
    ```

    `(1..)` создаёт бесконечный диапазон. Без `lazy` это выполнялось бы
    вечно! С `lazy` вычисляются только нужные значения.

    Простое число больше 1 и делится только на 1 и на себя.
  MD
  e.hints = [
    "Use (2..).lazy to start from 2",
    "Create a prime? helper or inline check",
    "A number n is prime if (2...n).none? { |i| n % i == 0 }"
  ]
  e.hints_ru = [
    "Используйте (2..).lazy, чтобы начать с 2",
    "Создайте вспомогательный метод prime? или проверку inline",
    "Число n простое, если (2...n).none? { |i| n % i == 0 }"
  ]
  e.starter_code = <<~RUBY
    def first_n_primes(n)
      # Use lazy enumeration to find first n primes
    end
  RUBY
  e.solution_code = <<~RUBY
    def first_n_primes(n)
      prime? = ->(num) { num > 1 && (2...num).none? { |i| num % i == 0 } }

      (2..).lazy
        .select { |num| prime?.call(num) }
        .take(n)
        .to_a
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe "first_n_primes" do
      it "returns first 5 primes" do
        expect(first_n_primes(5)).to eq([2, 3, 5, 7, 11])
      end

      it "returns first 10 primes" do
        expect(first_n_primes(10)).to eq([2, 3, 5, 7, 11, 13, 17, 19, 23, 29])
      end

      it "returns empty for 0" do
        expect(first_n_primes(0)).to eq([])
      end

      it "returns single prime for 1" do
        expect(first_n_primes(1)).to eq([2])
      end
    end
  RUBY
  e.topics = [ "lazy", "infinite sequences", "performance" ]
  e.points = 30
end

Exercise.find_or_create_by!(lesson: advanced_lesson, position: 5) do |e|
  e.title = "Endless Method"
  e.title_ru = "Бесконечный метод"
  e.description = "Use Ruby 3.0+ endless method definition for one-liners."
  e.description_ru = "Используйте определение бесконечных методов Ruby 3.0+ для однострочников."
  e.instructions = <<~MD
    Ruby 3.0+ introduced endless method definitions for simple one-liner methods.

    Instead of:
    ```ruby
    def double(x)
      x * 2
    end
    ```

    You can write:
    ```ruby
    def double(x) = x * 2
    ```

    Create a module `MathHelpers` with these endless methods:
    1. `square(n)` - returns n squared
    2. `cube(n)` - returns n cubed
    3. `average(a, b)` - returns average of two numbers
  MD
  e.instructions_ru = <<~MD
    Ruby 3.0+ представил определение бесконечных методов для простых однострочных методов.

    Вместо:
    ```ruby
    def double(x)
      x * 2
    end
    ```

    Вы можете написать:
    ```ruby
    def double(x) = x * 2
    ```

    Создайте модуль `MathHelpers` с этими бесконечными методами:
    1. `square(n)` - возвращает n в квадрате
    2. `cube(n)` - возвращает n в кубе
    3. `average(a, b)` - возвращает среднее двух чисел
  MD
  e.hints = [
    "def method(args) = expression",
    "No 'end' keyword needed",
    "Perfect for simple one-liner methods"
  ]
  e.hints_ru = [
    "def method(args) = expression",
    "Ключевое слово 'end' не нужно",
    "Идеально подходит для простых однострочных методов"
  ]
  e.starter_code = <<~RUBY
    module MathHelpers
      # Define square, cube, and average as endless methods
    end
  RUBY
  e.solution_code = <<~RUBY
    module MathHelpers
      def self.square(n) = n * n
      def self.cube(n) = n * n * n
      def self.average(a, b) = (a + b) / 2.0
    end
  RUBY
  e.test_code = <<~RUBY
    RSpec.describe MathHelpers do
      describe ".square" do
        it "returns n squared" do
          expect(MathHelpers.square(4)).to eq(16)
          expect(MathHelpers.square(-3)).to eq(9)
        end
      end

      describe ".cube" do
        it "returns n cubed" do
          expect(MathHelpers.cube(2)).to eq(8)
          expect(MathHelpers.cube(3)).to eq(27)
        end
      end

      describe ".average" do
        it "returns average of two numbers" do
          expect(MathHelpers.average(10, 20)).to eq(15.0)
          expect(MathHelpers.average(1, 2)).to eq(1.5)
        end
      end
    end
  RUBY
  e.topics = [ "endless methods", "ruby 3.0+", "syntax" ]
  e.points = 15
end

# =============================================================================
# ACHIEVEMENTS
# =============================================================================

# Points-based achievements
Achievement.find_or_create_by!(name: "First Points") do |a|
  a.description = "Earn your first 10 points"
  a.badge_icon = "⭐"
  a.category = :points
  a.points_required = 10
end

Achievement.find_or_create_by!(name: "Century") do |a|
  a.description = "Earn 100 points"
  a.badge_icon = "💯"
  a.category = :points
  a.points_required = 100
end

Achievement.find_or_create_by!(name: "Point Hoarder") do |a|
  a.description = "Earn 500 points"
  a.badge_icon = "💰"
  a.category = :points
  a.points_required = 500
end

Achievement.find_or_create_by!(name: "Point Master") do |a|
  a.description = "Earn 1000 points"
  a.badge_icon = "👑"
  a.category = :points
  a.points_required = 1000
end

# Exercise-based achievements
Achievement.find_or_create_by!(name: "Getting Started") do |a|
  a.description = "Complete 5 exercises"
  a.badge_icon = "🎯"
  a.category = :exercises
  a.exercises_required = 5
end

Achievement.find_or_create_by!(name: "On a Roll") do |a|
  a.description = "Complete 10 exercises"
  a.badge_icon = "🚀"
  a.category = :exercises
  a.exercises_required = 10
end

Achievement.find_or_create_by!(name: "Dedicated Learner") do |a|
  a.description = "Complete 20 exercises"
  a.badge_icon = "📚"
  a.category = :exercises
  a.exercises_required = 20
end

Achievement.find_or_create_by!(name: "Ruby Expert") do |a|
  a.description = "Complete all 61 exercises"
  a.badge_icon = "💎"
  a.category = :exercises
  a.exercises_required = 61
end

# Streak-based achievements
Achievement.find_or_create_by!(name: "Three Day Streak") do |a|
  a.description = "Maintain a 3-day learning streak"
  a.badge_icon = "🔥"
  a.category = :streak
  a.streak_required = 3
end

Achievement.find_or_create_by!(name: "Week Warrior") do |a|
  a.description = "Maintain a 7-day learning streak"
  a.badge_icon = "📅"
  a.category = :streak
  a.streak_required = 7
end

Achievement.find_or_create_by!(name: "Fortnight Fighter") do |a|
  a.description = "Maintain a 14-day learning streak"
  a.badge_icon = "⚔️"
  a.category = :streak
  a.streak_required = 14
end

Achievement.find_or_create_by!(name: "Month Master") do |a|
  a.description = "Maintain a 30-day learning streak"
  a.badge_icon = "🏆"
  a.category = :streak
  a.streak_required = 30
end

# Special achievements
Achievement.find_or_create_by!(name: "First Steps") do |a|
  a.description = "Complete your first exercise"
  a.badge_icon = "👶"
  a.category = :special
end

Achievement.find_or_create_by!(name: "Perfect Score") do |a|
  a.description = "Complete an exercise on the first try"
  a.badge_icon = "💯"
  a.category = :special
end

Achievement.find_or_create_by!(name: "Night Owl") do |a|
  a.description = "Submit code between 10 PM and 6 AM"
  a.badge_icon = "🦉"
  a.category = :special
end

Achievement.find_or_create_by!(name: "Speed Demon") do |a|
  a.description = "Pass tests with execution time under 100ms"
  a.badge_icon = "⚡"
  a.category = :special
end

# =============================================================================
# Summary
# =============================================================================

puts ""
puts "=" * 60
puts "Seeding complete!"
puts "=" * 60
puts ""
puts "Created:"
puts "  - #{Lesson.count} lessons"
puts "  - #{Exercise.count} exercises"
puts "  - #{Achievement.count} achievements"
puts ""
puts "Modules:"
Lesson.ordered.group_by(&:module_number).each do |mod_num, lessons|
  mod_names = {
    1 => "Ruby Basics",
    2 => "Working with Data",
    3 => "Object-Oriented Ruby",
    4 => "Ruby 3.4 Features"
  }
  exercise_count = lessons.sum { |l| l.exercises.count }
  puts "  Module #{mod_num}: #{mod_names[mod_num]} - #{lessons.count} lessons, #{exercise_count} exercises"
end
puts ""
puts "Total points available: #{Exercise.sum(:points)}"
puts ""
puts "Achievements by category:"
Achievement.group(:category).count.each do |category, count|
  puts "  #{category.capitalize}: #{count}"
end
puts ""
puts "Done!"
