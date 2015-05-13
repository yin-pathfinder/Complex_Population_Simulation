function characterNew = reproduce(character1,character2,seed)
characterNew = [character1(1:seed-1);character2(seed:end)];
end