# ruby_magnets_on_shoes.rb
class RubyMagnets < Shoes
  url '/', :index
	url '/(.+)', :index
  
  def get_position line, start = 0
    max = line.length
    sp = line.index(/(\.\.\.\.*? )/)
    return sp unless sp
    ep = sp
    nil while line[ep+=1] == '.'
    @pos << [start + sp, start + ep]
    ep += 1
    get_position(line[ep..-1], start + ep)
  end
  
  def answer
    Shoes.show_log
    i = -1
    QUIZ.gsub(/(\.\.\.\.*? )/){ "#{inside_code(i+=1)} "}
  end
  
  def inside_code i
    x0, y0, x1, y1 = @spaces[i]
    magnets = []
    @magnets.each{|m| (magnets << m) if m.left > x0 and m.left < x1 and m.top > y0 and m.top < y1}
    magnets.empty? ? '' : magnets.sort_by{|m| m.left}.collect{|m| m.style[:code]}.join(' ')
  end
  
  def show_result
    extra_code = "\na == #{RESULT} ? " +
      "\"Congrats!\nOutput is \#{a}\" : \"Umm... something is wrong...\nOutput is \#{a}\""
    begin
      msg = eval(answer + extra_code, TOPLEVEL_BINDING)
      info msg
    rescue => e
      error e
    end
  end
	
	def index n = '0'
		Dir['quizzes/*.rb'].length.times do |i|
		  flow(width: 80, height: 30, margin: 2){para link("QUIZ#{i+1}"){visit "/#{i+1}"}}
	  end
   
		begin
	  	load("quizzes/quiz#{n}.rb")
      
      @spaces = []
      QUIZ.each_line.with_index do |line, n|
        @pos = []
        get_position line
        @pos.each{|x, y| @spaces << [x*8, n*20+20, y*8, (n+1)*20+20]} unless @pos.empty?
      end
      
      flow do
        background blanchedalmond
        QUIZ.each_line{|line| inscription code(line), stroke: line[0] == '#' ? green : black}
      end
  
      @magnets = []
      MAGNETS.each_line do |line|
        magnet = flow width: line.length * 8, height: 20, margin: 2, code: line.chomp do
          background lightblue
          border black, strokewidth: 1
          inscription code(line), align: 'center', margin: 0
        end
        @magnets << magnet
        magnet.click{@flag = true; @magnet = magnet}
        magnet.release{@flag = false}
        motion{|left, top| @magnet.move(left-10, top-10) if @flag}
      end
      
      stack margin_top: 10 do
        para link('check your answer'){show_result}
      end
		end unless n == '0'
    
    #debug script: to check @spaces data
    #pos = para
    #motion{|left, top| pos.text = "#{left}  #{top}"}
    #click{|b, l, t| open('spaces_data.txt', 'a'){|f| f.puts "[#{l}, #{t}], "}}
     
	end
end

Shoes.app title: 'Ruby Magnets on Shoes!', width: 700, height: 650
