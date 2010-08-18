# quiz1.rb
QUIZ = <<EOS
# We have an array a, which we want to sort in simple ascending order, 
# but with all zeroes at the end of the array.

def another_sort a
  inf = .......... 
  a.sort_by { |x| .......... ? .......... : .......... }
end


# test snippet
a = [1, 0, 4, 2, 0, 8, 9]

a = another_sort(a)
#=> [1, 2, 4, 8, 9, 0, 0]
EOS

MAGNETS =<<EOS
x == 0
x != 0
1.0 / 0
0 / 1.0
x
inf
EOS

RESULT = [1, 2, 4, 8, 9, 0, 0]
