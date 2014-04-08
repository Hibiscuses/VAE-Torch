-- Based on JoinTable module

require 'nn'

local Reparametrize, parent = torch.class('nn.Reparametrize', 'nn.Module')

function Reparametrize:__init(dimension)
    parent.__init(self)
    self.size = torch.LongStorage()
    self.dimension = dimension
    self.gradInput = {}
end 

function Reparametrize:updateOutput(input)
    self.mu = input[1]:clone()
    self.sigma = input[2]:clone()

    self.eps = torch.randn(input[2]:size())
    self.output = torch.mul(input[2],0.5):exp():cmul(self.eps)

    -- Add the mean_
    self.output:add(input[1])

    return self.output
end

function Reparametrize:updateGradInput(input, gradOutput)
    -- Derivative with respect to mean is 1
    self.gradInput[1] = gradOutput:clone()
    
    --Not sure if this gradient is right
    self.gradInput[2] = torch.mul(input[2],0.5):exp():cmul(self.eps)
    self.gradInput[2]:cmul(gradOutput)

    return self.gradInput
end
