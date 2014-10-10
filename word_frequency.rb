#! /usr/local/bin/ruby

require 'benchmark'
include Benchmark

text=DATA.read
n = 500

bmbm do |b|
  b.report("variables with sort")    do
    n.times do
      frequencies = {}

      words = text.downcase.scan(/\w+/)
      words.each do |word|
        freq = frequencies.include?(word) ? frequencies[word] : 0
        frequencies[word] = freq + 1
      end

      sorted_frequencies = frequencies.sort{|freq1, freq2| freq2[1] <=> freq1[1]}

    end
  end

  b.report("variables with sort_by and include?") do
    n.times do
      frequencies = {}
      sorted_frequencies=text.downcase.scan(/\w+/).each do |word|
        freq = frequencies.include?(word) ? frequencies[word] : 0
        frequencies[word] = freq + 1
      end
      frequencies.sort_by{|f,w|w}.reverse
    end
  end

  b.report("variables with sort_by and || and freq") do
    n.times do
      frequencies = {}
      sorted_frequencies=text.downcase.scan(/\w+/).each do |word|
        freq = frequencies[word] || 0
        frequencies[word] = freq + 1
      end
      frequencies.sort_by{|f,w|w}.reverse
    end
  end

  b.report("variables with sort_by and || without freq") do
    n.times do
      frequencies = {}
      text.downcase.scan(/\w+/).each do |word|
        frequencies[word] = (frequencies[word] || 0) + 1
      end
      frequencies.sort_by{|f,w|w}.reverse
    end
  end

  b.report("variables with sort_by and ||= 0 without freq") do
    n.times do
      frequencies = {}
      text.downcase.scan(/\w+/).each do |word|
        frequencies[word] ||= 0
        frequencies[word]+= 1
      end
      frequencies.sort_by{|f,w|w}.reverse
    end
  end

  b.report("variables with sort_by without freq with Hash.new(0)") do
    n.times do
      frequencies = Hash.new(0)
      text.downcase.scan(/\w+/).each do |word|
        frequencies[word]+= 1
      end
      frequencies.sort_by{|f,w|w}.reverse
    end
  end

  b.report("variables with sort_by and || without each") do
    n.times do
      frequencies = {}
      text.downcase.scan(/\w+/) do |word|
        freq = frequencies[word] || 0
        frequencies[word] = freq + 1
      end
      frequencies.sort_by{|f,w|w}.reverse
    end
  end

  b.report("method chain with sort_by and Hash.new(0) and inject") do
    n.times do
      text.downcase.scan(/\w+/).inject(Hash.new 0){|h,w|h[w]+=1;h}.sort_by{|f,w|w}.reverse
    end
  end

  b.report("method chain with sort_by and Hash.new(0) without inject") do
    n.times do
      f = Hash.new(0)
      text.downcase.scan(/\w+/).each{|w|f[w]+=1}
      f.sort_by{|f,w|w}.reverse
    end
  end

  words = text.downcase.scan(/\w+/)
  b.report("method chain, sort_by, Hash.new(0), no inject, cached words") do
    n.times do
      f = Hash.new(0)
      words.each{|w|f[w]+=1}
      f.sort_by{|f,w|w}.reverse
    end
  end

  f = Hash.new(0)
  text.downcase.scan(/\w+/).each{|w|f[w]+=1}
  sorted_words = f.sort_by{|f,w|w}
  b.report("cached everything but reverse") do
    n.times do
      sorted_words.reverse
    end
  end

  b.report("nothing") do
    n.times do
    end
  end
end



#sorted_frequencies.first(10).each {|w,f| puts "%5d %s" % [ f, w ] }
#sorted_frequencies.first(10).each {|wf| puts "%5d %s" % wf.reverse }


__END__

When the world wants to talk, it speaks Unicode. Register now for the Tenth
  International Unicode Conference, to be held on March 10-12, 1997, in Mainz,
    Germany. The Conference will bring together industry-wide experts on the
  global Internet and Unicode, internationalization and localization,
    implementation of Unicode in operating systems and applications, fonts,
    text layout, and multilingual computing.
September

Of all the kids in the seventh grade at
Camillo Junior High, there was one kid
that Mrs. Baker hated with heat whiter
than the sun.
Me.
And let me tell you, it wasn't for
anything I'd done.
If it had been Doug Swieteck that Mrs.
Baker hated, it would have made sense.
Doug Swieteck once made up a list of 410
ways to get a teacher to hate you. It
began with "Spray deodorant in all her
desk drawers" and got worse as it went
along. A whole lot worse. I think that
things became illegal around Number 167.
You don't want to know what Number 400
was, and you really don't want to know
what Number 410 was. But I'll tell you
this much: They were the kinds of things
that sent kids to juvenile detention
homes in upstate New York, so far away
that you never saw them again.
Doug Swieteck tried Number 6 on Mrs.
Sidman last year. It was something about
Wrigley gum and the teachers' water
fountain (which was just outside the
teachers' lounge) and the Polynesian
Fruit Blend hair coloring that Mrs.
Sidman used. It worked, and streams of
juice the color of mangoes stained her
face for the rest of the day, and the
next day, and the next day--until, I
suppose, those skin cells wore off.
Doug Swieteck was suspended for two
whole weeks. Just before he left, he
said that next year he was going to try
Number 166 to see how much time that
would get him.
The day before Doug Swieteck came back,
our principal reported during Morning
Announcements that Mrs. Sidman had
accepted "voluntary reassignment to the
Main Administrative Office." We were all
supposed to congratulate her on the new
post. But it was hard to congratulate
her because she almost never peeked out
of the Main Administrative Office. Even
when she had to be the playground
monitor during recess, she mostly kept
away from us. If you did get close,
she'd whip out a plastic rain hat and
pull it on.
It's hard to congratulate someone who's
holding a plastic rain hat over her
Polynesian Fruit Blend-colored hair.
See? That's the kind of stuff that gets
teachers to hate you.
But the thing was, I never did any of
that stuff. Never. I even stayed as far
away from Doug Swieteck as I could, so
if he did decide to try Number 166 on
anyone, I wouldn't get blamed for
standing nearby.
But it didn't matter. Mrs. Baker hated
me. She hated me a whole lot worse than
Mrs. Sidman hated Doug Swieteck.
I knew it on Monday, the first day of
seventh grade, when she called the class
roll--which told you not only who was in
the class but also where everyone lived.
If your last name ended in "berg" or
"zog" or "stein," you lived on the north
side. If your last name ended in "elli"
or "ini" or "o," you lived on the south
side. Lee Avenue cut right between them,
and if you walked out of Camillo Junior
High and followed Lee Avenue across Main
Street, past MacClean's Drug Store,
Goldman's Best Bakery, and the Five &
Ten-Cent Store, through another block
and past the Free Public Library, and
down one more block, you'd come to my
house--which my father had figured out
was right smack in the middle of town.
Not on the north side. Not on the south
side. Just somewhere in between. "It's
the Perfect House," he said.
But perfect or not, it was hard living
in between. On Saturday morning,
everyone north of us was at Temple
Beth-El. Late on Saturday afternoon,
everyone south of us was at mass at
Saint Adelbert's--which had gone modern
and figured that it didn't need to wake
parishioners up early. But on Sunday
morning--early--my family was at Saint
Andrew Presbyterian Church listening to
Pastor McClellan, who was old enough to
have known Moses. This meant that out of
the whole weekend there was only Sunday
afternoon left over for full baseball teams.
This hadn't been too much of a disaster
up until now. But last summer, Ben
Cummings moved to Connecticut so his
Announcements that Mrs. Sidman had
accepted "voluntary reassignment to the
Main Administrative Office." We were all
supposed to congratulate her on the new
post. But it was hard to congratulate
her because she almost never peeked out
of the Main Administrative Office. Even
when she had to be the playground
monitor during recess, she mostly kept
away from us. If you did get close,
she'd whip out a plastic rain hat and
pull it on.
It's hard to congratulate someone who's
holding a plastic rain hat over her
Polynesian Fruit Blend-colored hair.
See? That's the kind of stuff that gets
teachers to hate you.
But the thing was, I never did any of
that stuff. Never. I even stayed as far
away from Doug Swieteck as I could, so
if he did decide to try Number 166 on
anyone, I wouldn't get blamed for
standing nearby.
But it didn't matter. Mrs. Baker hated
me. She hated me a whole lot worse than
Mrs. Sidman hated Doug Swieteck.
I knew it on Monday, the first day of
seventh grade, when she called the class
roll--which told you not only who was in
the class but also where everyone lived.
If your last name ended in "berg" or
"zog" or "stein," you lived on the north
side. If your last name ended in "elli"
or "ini" or "o," you lived on the south
side. Lee Avenue cut right between them,
and if you walked out of Camillo Junior
High and followed Lee Avenue across Main
Street, past MacClean's Drug Store,
Goldman's Best Bakery, and the Five &
Ten-Cent Store, through another block
and past the Free Public Library, and
down one more block, you'd come to my
house--which my father had figured out
was right smack in the middle of town.
Not on the north side. Not on the south
side. Just somewhere in between. "It's
the Perfect House," he said.
But perfect or not, it was hard living
in between. On Saturday morning,
everyone north of us was at Temple
Beth-El. Late on Saturday afternoon,
everyone south of us was at mass at
Saint Adelbert's--which had gone modern
and figured that it didn't need to wake
parishioners up early. But on Sunday
morning--early--my family was at Saint
Andrew Presbyterian Church listening to
Pastor McClellan, who was old enough to
have known Moses. This meant that out of
the whole weekend there was only Sunday
afternoon left over for full baseball teams.
This hadn't been too much of a disaster
up until now. But last summer, Ben
Cummings moved to Connecticut so his
