class CalcController < ApplicationController


  def index
  end

# Не стал выносить логику в отдельную модель или в отдельный фаил бизнес логики или модуль, хотя конечно оно должно жить там

# это самый простой и быстрый вариант и менее фанатичный. Да тут я использую eval и с входящими параметрами нужно быть аккуратнее,
# поэтому я сначала сериализую данные чтоб не попал на инекцию и уже потом уже использую.
  def string_calc
    incoming_string = params[:q]
    serializ_string = incoming_string.gsub(/[A-Za-z\p{Cyrillic}]/, "").gsub(/,/, '.')
    begin
      @result_calc = eval(serializ_string)
    rescue SyntaxError
      @result_calc = "синтаксическая ошибка в строке запроса"
    end
  end

# Не стал выносить логику из контроллера... up

# тут происходит фактически тоже самое что и 1й вариант,
# но более фанатично так как добавлен фильтр и онже перегонит в масиив каждый элемент,
# далее добавлена проверка каждого элемента массива на доступный символ и если появиться какой либо другой
# то логика выкинет ошибку синтаксиса на вьюху
# и того 3и степени фильтра перед попаданием в evel
# Тут если и всплывет ошибка синтаксиса то только в неверном алгоритме запроса

  def string_calc_two
    incoming_string = params[:q]
    serializ_string = incoming_string.gsub(/[A-Za-z\p{Cyrillic}]/, "").gsub(/,/, '.')

    data_result = serializ_string.scan(/[-,+,*,\'\/\',\.,\(,\),\d]/)

    sintax_err = false
    access_symbol = "0123456789.()+-*/".split("")

    data_result.map do |element|
      unless access_symbol.include?(element)
        sintax_err = true
        break
      end
    end
    if sintax_err
      @result_calc = "синтаксическая ошибка в строке запроса"
    else
      begin
        @result_calc = eval(data_result.join)
      rescue SyntaxError
        @result_calc = "синтаксическая ошибка в строке запроса"
      end
    end


  end


end
