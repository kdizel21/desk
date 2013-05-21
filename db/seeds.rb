# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#Create quiz

Quiz.create()

#create questions with answers

[{  :question => "Which is not an advantage of using a closure?",
    :answers => ["Prevent pollution of global scope","Encapsulation","Allow conditional use of 'strict mode'"],
    :correct_answer => ["Private properties and methods"]
   },
 {  :question => "To create a columned list of two ­ line email subjects and dates for a master ­ detail view, which is the most semantically correct?",
    :answers => ["<tr>+<td>","<p>+<br>", "<ul>+<li>", "none of these","all of these"],
    :correct_answer => ["<div>+<span>"]
 },
 {  :question => "To pass an array of strings to a function, you should not use...",
    :answers => ["fn.apply(this, stringsArray)","fn.call(this, stringsArray)"],
    :correct_answer => ["fn.bind(this, stringsArray)"]
   },
 {  :question => "____ and ____ would be the HTML tags you would use to display a menu item and its description.",
    :answers => ["<div>+<span>"],
    :correct_answer => ["<li>+<span>"]
 },
 {  :question => "Given <div id='outer'><div class='inner'></div></div>, which of these two is the most performant way to select the inner div?",
    :answers => ["getElementsByClassName('inner')[0]"],
    :correct_answer => ["getElementById('outer').children[0]"]
  }
 ].each do |qGroup|
  quizID = Quiz.first.id
  if quizID
    question = Question.create({ :group =>quizID, :question => qGroup[:question] })
    grouping = {:group => quizID, :question_group => question.id}
    if qGroup[:answers]
      qGroup[:answers].each do |a|
        Answer.create({
          :answer => a
        }.merge(grouping))
      end
    end

    qGroup[:correct_answer].each do |a|
      Answer.create({
        :answer => a,
        :correct => true
      }.merge(grouping))
    end
  end

end




