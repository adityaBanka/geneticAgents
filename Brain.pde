class Brain
{
  ArrayList <PVector> acceleration;
  
  int currentMove;
  int totalMoves;
  int currentTarget;

  boolean isAlive;

  double reward;
  double penalty;
  double fitness;

  int defaultBrainSize = 100;
  Brain()
  {
    acceleration = new ArrayList<PVector>();
    for(int i  = 0; i<defaultBrainSize; i++)
    {
      acceleration.add(new PVector(random(-1, 1), random(-1, 1)));
    }

    isAlive = true;
    currentMove = 0;
    totalMoves = defaultBrainSize-1;
    currentTarget = 0;

    reward = 0;
    penalty = 0;
    fitness = 0;
  }
//default constructor that specifies how many brain are made
  Brain(int size)
  {
    acceleration = new ArrayList<PVector>();
    for(int i  = 0; i<size; i++)
    {
      acceleration.add(new PVector(random(-1, 1), random(-1, 1)));
    }

    isAlive = true;
    currentMove = 0;
    totalMoves = size-1;
    currentTarget = 0;

    reward = 0;
    penalty = 0;
    fitness = 0;
  }

//a copy constructor that allows me to send brains to be copies
  Brain(Brain fittest)
  {
    int size = fittest.acceleration.size();
    acceleration = new ArrayList<PVector>();
    for(int i = 0; i<size; i++)
    {
      PVector temporary = fittest.acceleration.get(i);
      acceleration.add(new PVector(temporary.x, temporary.y));
    }
    isAlive = true;
    currentMove = 0;
    totalMoves = defaultBrainSize-1;
    currentTarget = 0;

    reward = 0;
    penalty = 0;
    fitness = 0;
  }


//the constructor that has the crossover feature 
  Brain(Brain first, Brain second)
  {
    int size1 = first.acceleration.size();
    int size2 = second.acceleration.size();
    if(size2 < size1)
    {
      int temp1 = size1;
      size1 = size2;
      size2 = temp1;

      Brain temp2 = first;
      first = second;
      second = temp2;
    }

    acceleration = new ArrayList<PVector>(); 
    for(int i = 0; i<size1; i++)
    {
      int randomNumber = (int)random(0, 10);
      PVector acceleration_to_be_copied;
      if(i % 2 == 0)
      acceleration_to_be_copied = first.acceleration.get(i);
      else
      acceleration_to_be_copied = second.acceleration.get(i);

      acceleration.add(new PVector(acceleration_to_be_copied.x, acceleration_to_be_copied.y));
    }
    for(int i = size1; i < size2; i++)
    {
      acceleration.add(new PVector(second.acceleration.get(i).x, second.acceleration.get(i).y));
    }

    isAlive = true;
    currentMove = 0;
    totalMoves = defaultBrainSize-1;
    currentTarget = 0;

    reward = 0;
    penalty = 0;
    fitness = 0;

  }

  void mutate(int generation, double percentage)
  {
    int count = 0;
    for(PVector acc : acceleration)
    {
      count++;
      if(count < generation)
      continue;
      double randomNumber = random(0, 100);
      if(randomNumber < percentage)
      {
        acc.x = random(-1, 1);
        acc.y = random(-1, 1);
      }
    }
  }

  void addRandom(int size)
  {
    for(int i = 0; i<size; i++)
    {
      acceleration.add(new PVector(random(-1, 1), random(-1, 1)));
    }
  }

  PVector fetchMove()
  {
    if(currentMove >= totalMoves)
      return(new PVector(0, 0));
    PVector move = acceleration.get(currentMove);
    currentMove++;
    if(currentMove >= totalMoves)
      {
        isAlive = false;
        //fitness += (reward - penalty);
      }
    return(move);
  }
}
