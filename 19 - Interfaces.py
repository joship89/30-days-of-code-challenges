from abc import ABCMeta, abstractmethod


class AdvancedArithmetic(object, metaclass=ABCMeta):
    @abstractmethod
    def divisorSum(self, n):
        pass

class Calculator(AdvancedArithmetic):
    def divisorSum(self, n):
        divisors_sum = 0
        for i in range(n):
            if n % i == 0:
                result += i
        return divisors_sum 

n = int(input())

myCalculator = Calculator()
total = myCalculator.divisorSum(n)
print("I implemented: " + str(AdvancedArithmetic))
print(total)



        
