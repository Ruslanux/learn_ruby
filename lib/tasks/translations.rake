# frozen_string_literal: true

namespace :translations do
  desc "Add Russian translations to lessons and exercises"
  task seed_russian: :environment do
    puts "Adding Russian translations..."

    # Module 1: Ruby Basics
    lesson = Lesson.find_by(title: "Hello World")
    if lesson
      lesson.update!(
        title_ru: "Привет, мир!",
        description_ru: "Изучите основы функций Ruby и возвращаемых значений. Это ваш первый шаг в программировании на Ruby!"
      )

      lesson.exercises.find_by(title: "Say Hello")&.update!(
        title_ru: "Скажи привет",
        description_ru: "Создайте свою первую функцию Ruby, которая возвращает приветствие.",
        instructions_ru: "Создайте функцию `hello`, которая возвращает строку \"Hello!\".\n\nВ Ruby функции определяются с помощью ключевого слова `def`. Последнее выражение в функции автоматически возвращается.",
        hints_ru: [
          "Функции определяются с помощью def...end",
          "Ruby автоматически возвращает последнее выражение",
          "Строки создаются с помощью кавычек: \"Hello!\""
        ]
      )

      lesson.exercises.find_by(title: "Greet Someone")&.update!(
        title_ru: "Поприветствуй кого-нибудь",
        description_ru: "Создайте функцию, которая принимает имя и возвращает персонализированное приветствие.",
        instructions_ru: "Создайте функцию `greet`, которая принимает параметр `name` и возвращает \"Hello, {name}!\", где {name} заменяется на фактическое имя.\n\nИспользуйте интерполяцию строк с `\#{переменная}` внутри двойных кавычек.",
        hints_ru: [
          "Используйте интерполяцию строк: \"Hello, \#{name}!\"",
          "Параметры указываются в скобках после имени функции",
          "Убедитесь, что используете двойные кавычки для интерполяции"
        ]
      )

      lesson.exercises.find_by(title: "Default Greeting")&.update!(
        title_ru: "Приветствие по умолчанию",
        description_ru: "Создайте функцию со значением параметра по умолчанию.",
        instructions_ru: "Создайте функцию `greet_with_default`, которая принимает необязательный параметр `name`.\n\n- Если имя указано, верните \"Hello, {name}!\"\n- Если имя не указано, используйте значение \"World\" по умолчанию\n\nИспользуйте синтаксис параметров по умолчанию: `def method(param = default_value)`",
        hints_ru: [
          "Используйте def greet_with_default(name = \"World\")",
          "Значение по умолчанию используется, когда аргумент не передан",
          "Вы всё ещё можете использовать интерполяцию строк"
        ]
      )
    end

    lesson = Lesson.find_by(title: "Temperature Converter")
    if lesson
      lesson.update!(
        title_ru: "Конвертер температуры",
        description_ru: "Изучите базовые математические операции, создавая функции конвертации температуры."
      )

      lesson.exercises.find_by(title: "Fahrenheit to Celsius")&.update!(
        title_ru: "Фаренгейт в Цельсий",
        description_ru: "Конвертируйте температуру из Фаренгейта в Цельсий.",
        instructions_ru: <<~MD,
          Создайте функцию `ftoc`, которая конвертирует Фаренгейт в Цельсий.

          Формула: C = (F - 32) * 5/9

          Убедитесь, что возвращаете значение с плавающей точкой.
        MD
        hints_ru: [
          "Используйте формулу: (fahrenheit - 32) * 5.0 / 9.0",
          "Используйте 5.0 вместо 5 для деления с плавающей точкой",
          "Ruby автоматически возвращает последнее выражение"
        ]
      )

      lesson.exercises.find_by(title: "Celsius to Fahrenheit")&.update!(
        title_ru: "Цельсий в Фаренгейт",
        description_ru: "Конвертируйте температуру из Цельсия в Фаренгейт.",
        instructions_ru: <<~MD,
          Создайте функцию `ctof`, которая конвертирует Цельсий в Фаренгейт.

          Формула: F = C * 9/5 + 32
        MD
        hints_ru: [
          "Используйте формулу: celsius * 9.0 / 5.0 + 32",
          "Это обратная функция к ftoc"
        ]
      )
    end

    lesson = Lesson.find_by(title: "Calculator")
    if lesson
      lesson.update!(
        title_ru: "Калькулятор",
        description_ru: "Создайте калькулятор с различными операциями. Изучите массивы и итерацию."
      )

      lesson.exercises.find_by(title: "Add Two Numbers")&.update!(
        title_ru: "Сложение двух чисел",
        description_ru: "Создайте простую функцию сложения.",
        instructions_ru: "Создайте функцию `add`, которая принимает два числа и возвращает их сумму.",
        hints_ru: ["Используйте оператор +"]
      )

      lesson.exercises.find_by(title: "Sum an Array")&.update!(
        title_ru: "Сумма массива",
        description_ru: "Суммируйте все числа в массиве, используя встроенные методы Ruby.",
        instructions_ru: <<~MD,
          Создайте функцию `sum`, которая принимает массив чисел и возвращает их сумму.

          Подсказка: у массивов Ruby есть метод `sum`!
        MD
        hints_ru: [
          "Попробуйте использовать метод .sum для массивов",
          "Или используйте .reduce(:+) для более ручного подхода"
        ]
      )

      lesson.exercises.find_by(title: "Factorial")&.update!(
        title_ru: "Факториал",
        description_ru: "Вычислите факториал числа.",
        instructions_ru: <<~MD,
          Создайте функцию `factorial`, которая вычисляет n! (n факториал).

          factorial(0) = 1
          factorial(5) = 5 * 4 * 3 * 2 * 1 = 120

          Вы можете использовать рекурсию или итерацию.
        MD
        hints_ru: [
          "Базовый случай: factorial(0) = 1",
          "Попробуйте использовать (1..n).reduce(1, :*)",
          "Или используйте рекурсию: n * factorial(n-1)"
        ]
      )
    end

    lesson = Lesson.find_by(title: "Conditionals")
    if lesson
      lesson.update!(
        title_ru: "Условные операторы",
        description_ru: "Научитесь принимать решения в коде с помощью операторов if, else и case."
      )

      lesson.exercises.find_by(title: "Is Even?")&.update!(
        title_ru: "Чётное?",
        description_ru: "Проверьте, является ли число чётным или нечётным.",
        instructions_ru: <<~MD,
          Создайте функцию `even?`, которая возвращает `true`, если число чётное, и `false` в противном случае.

          Подсказка: используйте оператор остатка от деления `%` для проверки делимости.
        MD
        hints_ru: [
          "Число чётное, если n % 2 == 0",
          "У целых чисел Ruby есть встроенный метод .even?",
          "Вы можете использовать любой из подходов"
        ]
      )

      lesson.exercises.find_by(title: "FizzBuzz")&.update!(
        title_ru: "FizzBuzz",
        description_ru: "Классическое программистское задание!",
        instructions_ru: <<~MD,
          Создайте функцию `fizzbuzz`, которая принимает число и возвращает:

          - "FizzBuzz", если число делится и на 3, и на 5
          - "Fizz", если число делится на 3
          - "Buzz", если число делится на 5
          - Число в виде строки в противном случае
        MD
        hints_ru: [
          "Сначала проверяйте делимость и на 3, и на 5",
          "Используйте n % 3 == 0 для проверки делимости на 3",
          "Используйте .to_s для преобразования числа в строку"
        ]
      )

      lesson.exercises.find_by(title: "Grade Calculator")&.update!(
        title_ru: "Калькулятор оценок",
        description_ru: "Преобразуйте числовой балл в буквенную оценку.",
        instructions_ru: <<~MD,
          Создайте функцию `grade`, которая принимает балл (0-100) и возвращает буквенную оценку:

          - 90-100: "A"
          - 80-89: "B"
          - 70-79: "C"
          - 60-69: "D"
          - Ниже 60: "F"
        MD
        hints_ru: [
          "Используйте if/elsif/else или оператор case",
          "Проверяйте от высшего к низшему",
          "С case можно использовать диапазоны: when 90..100"
        ]
      )
    end

    # Module 2: Working with Data
    lesson = Lesson.find_by(title: "Arrays")
    if lesson
      lesson.update!(
        title_ru: "Массивы",
        description_ru: "Освойте массивы Ruby с мощными встроенными методами для работы с данными."
      )

      lesson.exercises.find_by(title: "First and Last")&.update!(
        title_ru: "Первый и последний",
        description_ru: "Получите первый и последний элементы массива.",
        instructions_ru: <<~MD,
          Создайте функцию `first_and_last`, которая принимает массив и возвращает
          новый массив, содержащий только первый и последний элементы.

          Пример: `first_and_last([1, 2, 3, 4])` возвращает `[1, 4]`
        MD
        hints_ru: [
          "Используйте array.first и array.last",
          "Верните новый массив с [first, last]",
          "Обработайте крайние случаи, например, пустые массивы"
        ]
      )

      lesson.exercises.find_by(title: "Double Each")&.update!(
        title_ru: "Удвоить каждый",
        description_ru: "Преобразуйте каждый элемент массива.",
        instructions_ru: <<~MD,
          Создайте функцию `double_each`, которая принимает массив чисел
          и возвращает новый массив с каждым числом, умноженным на два.

          Используйте метод `map` для этого преобразования.
        MD
        hints_ru: [
          "Используйте .map для преобразования каждого элемента",
          "map возвращает новый массив",
          "Пример: [1,2].map { |n| n * 2 } возвращает [2,4]"
        ]
      )

      lesson.exercises.find_by(title: "Select Evens")&.update!(
        title_ru: "Выбрать чётные",
        description_ru: "Отфильтруйте массив, оставив только чётные числа.",
        instructions_ru: <<~MD,
          Создайте функцию `select_evens`, которая принимает массив чисел
          и возвращает новый массив, содержащий только чётные числа.

          Используйте метод `select` для фильтрации.
        MD
        hints_ru: [
          "Используйте .select для фильтрации элементов",
          "select оставляет элементы, для которых блок возвращает true",
          "Используйте n.even? или n % 2 == 0"
        ]
      )

      lesson.exercises.find_by(title: "Find Maximum")&.update!(
        title_ru: "Найти максимум",
        description_ru: "Найдите наибольший элемент в массиве.",
        instructions_ru: <<~MD,
          Создайте функцию `find_max`, которая принимает массив чисел
          и возвращает наибольшее число.

          Подсказка: у массивов есть встроенный метод `max`!
        MD
        hints_ru: [
          "Используйте метод .max",
          "Или используйте .reduce со сравнением",
          "Обработайте пустые массивы (верните nil)"
        ]
      )
    end

    lesson = Lesson.find_by(title: "Hashes")
    if lesson
      lesson.update!(
        title_ru: "Хэши",
        description_ru: "Научитесь работать с мощной структурой данных Ruby — хэшами (ключ-значение)."
      )

      lesson.exercises.find_by(title: "Create a Person Hash")&.update!(
        title_ru: "Создать хэш человека",
        description_ru: "Создайте хэш с информацией о человеке.",
        instructions_ru: <<~MD,
          Создайте функцию `create_person`, которая принимает имя и возраст
          и возвращает хэш с ключами `:name` и `:age`.

          Пример: `create_person("Alice", 30)` возвращает `{name: "Alice", age: 30}`
        MD
        hints_ru: [
          "Используйте символы как ключи: { name: value, age: value }",
          "Или используйте синтаксис со стрелкой: { :name => value }",
          "Оба синтаксиса работают одинаково"
        ]
      )

      lesson.exercises.find_by(title: "Get Hash Value")&.update!(
        title_ru: "Получить значение из хэша",
        description_ru: "Безопасно извлекайте значения из хэша со значениями по умолчанию.",
        instructions_ru: <<~MD,
          Создайте функцию `get_value`, которая принимает хэш, ключ и значение по умолчанию.
          Верните значение для ключа, если он существует, иначе верните значение по умолчанию.

          Используйте метод Ruby `fetch` со значением по умолчанию.
        MD
        hints_ru: [
          "Используйте hash.fetch(key, default)",
          "fetch возвращает default, если ключ не существует",
          "Это безопаснее, чем hash[key] || default"
        ]
      )

      lesson.exercises.find_by(title: "Count Words")&.update!(
        title_ru: "Подсчитать слова",
        description_ru: "Подсчитайте частоту слов в предложении.",
        instructions_ru: <<~MD,
          Создайте функцию `count_words`, которая принимает строку и возвращает
          хэш, где каждое слово является ключом, а его количество — значением.

          - Преобразуйте слова в нижний регистр
          - Разделяйте по пробелам

          Пример: `count_words("hello world hello")` возвращает `{"hello" => 2, "world" => 1}`
        MD
        hints_ru: [
          "Используйте .downcase.split для получения слов",
          "Используйте .tally для подсчёта (Ruby 2.7+)",
          "Или используйте .each_with_object({}) с инкрементом"
        ]
      )

      lesson.exercises.find_by(title: "Merge Hashes")&.update!(
        title_ru: "Объединить хэши",
        description_ru: "Объедините два хэша с пользовательской логикой слияния.",
        instructions_ru: <<~MD,
          Создайте функцию `merge_with_sum`, которая принимает два хэша с числовыми значениями
          и возвращает новый хэш, где значения совпадающих ключей суммируются.

          Пример:
          ```ruby
          merge_with_sum({a: 1, b: 2}, {b: 3, c: 4})
          # => {a: 1, b: 5, c: 4}
          ```
        MD
        hints_ru: [
          "Используйте .merge с блоком",
          "Блок получает key, old_val, new_val",
          "Верните old_val + new_val в блоке"
        ]
      )
    end

    lesson = Lesson.find_by(title: "Strings")
    if lesson
      lesson.update!(
        title_ru: "Строки",
        description_ru: "Освойте манипуляции со строками с помощью богатых строковых методов Ruby."
      )

      lesson.exercises.find_by(title: "Reverse a String")&.update!(
        title_ru: "Перевернуть строку",
        description_ru: "Переверните символы в строке.",
        instructions_ru: <<~MD,
          Создайте функцию `reverse_string`, которая принимает строку и возвращает её перевёрнутой.

          Пример: `reverse_string("hello")` возвращает `"olleh"`
        MD
        hints_ru: [
          "У строк Ruby есть метод .reverse",
          "Также можно использовать .chars.reverse.join",
          "Самое простое решение часто лучшее"
        ]
      )

      lesson.exercises.find_by(title: "Palindrome Check")&.update!(
        title_ru: "Проверка на палиндром",
        description_ru: "Проверьте, является ли строка палиндромом.",
        instructions_ru: <<~MD,
          Создайте функцию `palindrome?`, которая возвращает true, если строка
          читается одинаково слева направо и справа налево.

          Игнорируйте регистр при сравнении.

          Пример: `palindrome?("Racecar")` возвращает `true`
        MD
        hints_ru: [
          "Используйте .downcase для нормализации регистра",
          "Сравните строку с её перевёрнутой версией",
          "str.downcase == str.downcase.reverse"
        ]
      )

      lesson.exercises.find_by(title: "Title Case")&.update!(
        title_ru: "Заглавные буквы",
        description_ru: "Преобразуйте строку в формат заголовка.",
        instructions_ru: <<~MD,
          Создайте функцию `titleize`, которая преобразует строку в формат заголовка,
          где первая буква каждого слова заглавная.

          Пример: `titleize("hello world")` возвращает `"Hello World"`
        MD
        hints_ru: [
          "Разбейте на слова, сделайте каждое с заглавной, объедините обратно",
          "Используйте .split, .map и .join",
          "Для каждого слова: word.capitalize"
        ]
      )

      lesson.exercises.find_by(title: "Anagram Check")&.update!(
        title_ru: "Проверка на анаграмму",
        description_ru: "Проверьте, являются ли две строки анаграммами.",
        instructions_ru: <<~MD,
          Создайте функцию `anagram?`, которая возвращает true, если две строки
          являются анаграммами друг друга (содержат одинаковые буквы).

          - Игнорируйте регистр
          - Игнорируйте пробелы

          Пример: `anagram?("listen", "silent")` возвращает `true`
        MD
        hints_ru: [
          "Удалите пробелы и приведите обе строки к нижнему регистру",
          "Отсортируйте символы и сравните",
          "str.gsub(' ', '').downcase.chars.sort"
        ]
      )
    end

    # Module 3: Object-Oriented Ruby
    lesson = Lesson.find_by(title: "Classes and Objects")
    if lesson
      lesson.update!(
        title_ru: "Классы и объекты",
        description_ru: "Научитесь создавать классы, определять методы и работать с объектами."
      )

      lesson.exercises.find_by(title: "Dog Class")&.update!(
        title_ru: "Класс Dog",
        description_ru: "Создайте простой класс Dog с атрибутом имени.",
        instructions_ru: <<~MD,
          Создайте класс `Dog` с:

          - Методом `initialize`, который принимает параметр `name`
          - Атрибутом `name` для чтения
          - Методом `bark`, который возвращает "Woof!"
        MD
        hints_ru: [
          "Используйте attr_reader :name",
          "Инициализируйте с @name = name",
          "Метод bark просто возвращает строку"
        ]
      )

      lesson.exercises.find_by(title: "Counter Class")&.update!(
        title_ru: "Класс Counter",
        description_ru: "Создайте класс Counter с методами увеличения и уменьшения.",
        instructions_ru: <<~MD,
          Создайте класс `Counter` с:

          - Методом `initialize`, который устанавливает count в 0 (или необязательное начальное значение)
          - Атрибутом `count` для чтения
          - Методом `increment`, который увеличивает count на 1
          - Методом `decrement`, который уменьшает count на 1
        MD
        hints_ru: [
          "Используйте attr_reader :count",
          "Используйте @count += 1 для увеличения",
          "Параметр по умолчанию: def initialize(start = 0)"
        ]
      )

      lesson.exercises.find_by(title: "Rectangle Class")&.update!(
        title_ru: "Класс Rectangle",
        description_ru: "Создайте класс Rectangle с вычислением площади и периметра.",
        instructions_ru: <<~MD,
          Создайте класс `Rectangle` с:

          - `initialize(width, height)`
          - Атрибутами `width` и `height` для чтения
          - Методом `area`, возвращающим width * height
          - Методом `perimeter`, возвращающим 2 * (width + height)
          - Методом `square?`, возвращающим true, если width равен height
        MD
        hints_ru: [
          "Используйте attr_reader :width, :height",
          "Площадь = width * height",
          "Периметр = 2 * (width + height)"
        ]
      )
    end

    lesson = Lesson.find_by(title: "Modules and Mixins")
    if lesson
      lesson.update!(
        title_ru: "Модули и миксины",
        description_ru: "Научитесь использовать модули для пространств имён и совместного использования поведения."
      )

      lesson.exercises.find_by(title: "Greeting Module")&.update!(
        title_ru: "Модуль Greeting",
        description_ru: "Создайте модуль с методами приветствия для подмешивания в классы.",
        instructions_ru: <<~MD,
          Создайте модуль `Greetable` с:

          - Методом `greet`, который возвращает "Hello, I'm \#{name}!"
          - Предполагается, что класс имеет метод `name`

          Затем создайте класс `Person`, который:
          - Включает модуль `Greetable`
          - Имеет атрибут `name`, устанавливаемый в initialize
        MD
        hints_ru: [
          "Определите модуль с: module Greetable",
          "Используйте include Greetable в классе",
          "Модуль может вызывать методы из класса"
        ]
      )

      lesson.exercises.find_by(title: "Comparable Module")&.update!(
        title_ru: "Модуль Comparable",
        description_ru: "Реализуйте сравнение с помощью модуля Comparable.",
        instructions_ru: <<~MD,
          Создайте класс `Box`, который:

          - Имеет атрибут `volume` (устанавливается в initialize)
          - Включает модуль `Comparable`
          - Реализует оператор `<=>` (spaceship) для сравнения по объёму

          Это даст вам <, >, ==, <=, >= бесплатно!
        MD
        hints_ru: [
          "Включите Comparable",
          "Реализуйте def <=>(other)",
          "Верните volume <=> other.volume"
        ]
      )
    end

    # Module 4: Ruby 3.4 Features
    lesson = Lesson.find_by(title: "The 'it' Parameter")
    if lesson
      lesson.update!(
        title_ru: "Параметр 'it'",
        description_ru: "Изучите новое ключевое слово 'it' в Ruby 3.4 для блоков с одним параметром."
      )

      lesson.exercises.find_by(title: "Using 'it' in map")&.update!(
        title_ru: "Использование 'it' в map",
        description_ru: "Рефакторинг кода с использованием нового синтаксиса параметра 'it'.",
        instructions_ru: <<~MD,
          Ruby 3.4 ввёл `it` как сокращение для блоков с одним параметром.

          Вместо:
          ```ruby
          [1, 2, 3].map { |n| n * 2 }
          ```

          Можно написать:
          ```ruby
          [1, 2, 3].map { it * 2 }
          ```

          Создайте функцию `double_all`, которая удваивает каждое число с использованием `it`.
        MD
        hints_ru: [
          "Используйте .map { it * 2 }",
          "'it' автоматически ссылается на параметр блока",
          "Это работает только в Ruby 3.4+"
        ]
      )

      lesson.exercises.find_by(title: "Chaining with 'it'")&.update!(
        title_ru: "Цепочка вызовов с 'it'",
        description_ru: "Используйте 'it' для цепочки вызовов методов в блоках.",
        instructions_ru: <<~MD,
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
        hints_ru: [
          "Используйте .map { it.upcase }",
          "'it' — это параметр блока",
          "Вы можете вызывать любой метод на 'it'"
        ]
      )

      lesson.exercises.find_by(title: "Filter with 'it'")&.update!(
        title_ru: "Фильтрация с 'it'",
        description_ru: "Используйте 'it' с методами select и reject.",
        instructions_ru: <<~MD,
          Используйте `it` с методами фильтрации, такими как `select`.

          Создайте функцию `select_long_words`, которая возвращает слова
          длиннее 5 символов.

          Используйте `it.length > 5` в блоке select.
        MD
        hints_ru: [
          "Используйте .select { it.length > 5 }",
          "'it' работает с любым методом, принимающим блок",
          "select оставляет элементы, где блок возвращает true"
        ]
      )
    end

    lesson = Lesson.find_by(title: "Pattern Matching")
    if lesson
      lesson.update!(
        title_ru: "Сопоставление с образцом",
        description_ru: "Изучите мощный синтаксис сопоставления с образцом Ruby для деструктуризации данных."
      )

      lesson.exercises.find_by(title: "Array Destructuring")&.update!(
        title_ru: "Деструктуризация массива",
        description_ru: "Используйте сопоставление с образцом для извлечения значений из массивов.",
        instructions_ru: <<~MD,
          Создайте функцию `first_two`, которая использует сопоставление с образцом для извлечения
          первых двух элементов из массива.

          Используйте синтаксис сопоставления с `in`:
          ```ruby
          case array
          in [first, second, *rest]
            # используйте first и second
          end
          ```

          Верните массив только с первыми двумя элементами.
        MD
        hints_ru: [
          "Используйте case/in для сопоставления с образцом",
          "Используйте [a, b, *] для сопоставления первых двух и игнорирования остальных",
          "Верните [a, b]"
        ]
      )

      lesson.exercises.find_by(title: "Hash Pattern Matching")&.update!(
        title_ru: "Сопоставление с хэшем",
        description_ru: "Извлекайте значения из хэшей с помощью сопоставления с образцом.",
        instructions_ru: <<~MD,
          Создайте функцию `greet_user`, которая принимает хэш пользователя и возвращает
          приветствие в зависимости от роли пользователя.

          Используйте сопоставление с хэшем:
          ```ruby
          case user
          in { name:, role: "admin" }
            "Welcome back, Admin \#{name}!"
          in { name: }
            "Hello, \#{name}!"
          end
          ```
        MD
        hints_ru: [
          "Сопоставляйте ключи хэша напрямую: { name:, role: }",
          "Можно сопоставлять конкретные значения: role: \"admin\"",
          "Сопоставленные ключи становятся локальными переменными"
        ]
      )

      lesson.exercises.find_by(title: "Guard Clauses in Patterns")&.update!(
        title_ru: "Охранные условия в образцах",
        description_ru: "Добавьте условия к сопоставлению с образцом с помощью охранных условий.",
        instructions_ru: <<~MD,
          Создайте функцию `describe_number`, которая использует сопоставление с образцом с охранными условиями.

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
        hints_ru: [
          "Используйте 'in x if условие' для охранных условий",
          "Сопоставленное значение привязывается к x",
          "Обработайте каждый случай: 0, положительные, отрицательные"
        ]
      )
    end

    lesson = Lesson.find_by(title: "Data Classes")
    if lesson
      lesson.update!(
        title_ru: "Классы Data",
        description_ru: "Изучите класс Data из Ruby 3.2+ для неизменяемых объектов-значений."
      )

      lesson.exercises.find_by(title: "Create a Point Data Class")&.update!(
        title_ru: "Создать класс Point",
        description_ru: "Используйте Data.define для создания неизменяемого класса Point.",
        instructions_ru: <<~MD,
          Создайте класс данных `Point` с атрибутами `x` и `y`.

          Классы данных создаются с помощью:
          ```ruby
          Point = Data.define(:x, :y)
          ```

          Классы данных:
          - Неизменяемые (нельзя изменить значения после создания)
          - Имеют автоматическое равенство на основе значений
          - Имеют красивый вывод inspect/to_s
        MD
        hints_ru: [
          "Используйте Point = Data.define(:x, :y)",
          "Создавайте с Point.new(x: 1, y: 2) или Point[1, 2]",
          "Доступ через point.x и point.y"
        ]
      )

      lesson.exercises.find_by(title: "Data Class with Methods")&.update!(
        title_ru: "Data класс с методами",
        description_ru: "Добавьте методы в класс Data.",
        instructions_ru: <<~MD,
          Создайте класс данных `Circle` с атрибутом `radius` и добавьте методы:

          - `diameter` — возвращает radius * 2
          - `area` — возвращает Math::PI * radius ** 2

          Вы можете добавлять методы в классы Data, переоткрывая класс или используя блок:
          ```ruby
          Circle = Data.define(:radius) do
            def diameter
              radius * 2
            end
          end
          ```
        MD
        hints_ru: [
          "Используйте Data.define(:radius) do ... end",
          "Определяйте методы внутри блока",
          "Используйте Math::PI для числа пи"
        ]
      )

      lesson.exercises.find_by(title: "Data Class with Derived Values")&.update!(
        title_ru: "Data класс с вычисляемыми значениями",
        description_ru: "Создайте класс данных, который вычисляет производные значения.",
        instructions_ru: <<~MD,
          Создайте класс данных `Person` с атрибутами `first_name` и `last_name`.

          Добавьте метод `full_name`, который возвращает "\#{first_name} \#{last_name}".

          Также добавьте метод `initials`, который возвращает первую букву каждого имени.
          Пример: "John Doe" -> "JD"
        MD
        hints_ru: [
          "Используйте Data.define(:first_name, :last_name)",
          "full_name объединяет с пробелом",
          "initials: first_name[0] + last_name[0]"
        ]
      )
    end

    puts "Russian translations added!"
    puts "Updated #{Lesson.where.not(title_ru: nil).count} lessons"
    puts "Updated #{Exercise.where.not(title_ru: nil).count} exercises"
  end
end
