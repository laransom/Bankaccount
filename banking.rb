require 'csv'
require 'pry'


def format_currency(value)
  "$#{sprintf('%.2f', value.to_f.abs)}"
end


class BankAccount
  attr_reader :name, :transactions, :starting_balance
  attr_accessor :balance

  def initialize(name, balance)
    @name = name
    @starting_balance = balance.to_f
    @balance = balance.to_f
    @transactions = []
  end

  def add_transaction(trans_obj)
    @transactions << trans_obj
  end
end

class BankTransaction
  def initialize(date, amount, desc)
    @date = date
    @amount = amount
    @desc = desc
  end



  def debit?
    @amount < 0
  end

  def credit?
    @amount > 0
  end

  def summary
    if self.debit?
      type = "DEBIT"
    else
      type = "CREDIT"
    end
    puts "#{format_currency(@amount)} #{type} #{@date} - #{@desc}"
  end

end

accounts= []
i = 0
CSV.foreach('balances.csv', headers: true) do |row|
  accounts[i] = BankAccount.new(row[0], row[1])
  i+=1
end

i = 0
CSV.foreach('bank_data.csv', headers: true) do |row|
  accounts.each do |acct|
    if acct.name == row[3]

      acct.add_transaction(BankTransaction.new(row[0], row[1].to_f, row[2]))
      acct.balance += row[1].to_f
    end
  end
end

accounts.each do |acct|
  puts "==== #{acct.name} ===="
  puts "Starting Balance: #{format_currency(acct.starting_balance)}"
  puts "Ending Balance: #{format_currency(acct.balance)}"
  puts
  acct.transactions.each do |trans|
    trans.summary
  end
  puts "========"
  puts
end







