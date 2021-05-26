#include <iostream>
#include <cstdlib>
#include <ctime>
#include <string>
#include<limits>

int read_input()
{
    int num; //variable to store the number entered by the user.
    std::cin >> num;
    //While the input entered is not an integer, prompt the user to enter an integer.
    int count = 0;
    int recheck = 0;
    if(std::cin.fail() || num<1) recheck =1;
    while(1)
    {   
        if (count>2){std::cout<<"I give up with you! Give me real integers." << std::endl; exit(EXIT_FAILURE);}
        if(recheck)
        {
            std::cin.clear();
            std::cin.ignore(std::numeric_limits<std::streamsize>::max(),'\n');
            std::cout<< "You have entered wrong input" << std::endl;
            std::cin>>num;
            if(std::cin.fail() || num<1){recheck =1;count += 1;}
            else{recheck=0;}
        }
        else
            break;
    }

    return num;
}

int main()
{
    bool playing = true;
    std::string decision;
    /*
        This variable keeps track of whose turn it is. we can name it
        player1Turn, then when it's true, it's player 1's turn, when it's
        false it's player 2's turn.
    */
    bool player1Turn;
    int chipsInPile;
    int chipsTaken;
    int takechips;
    // declare a boolean variable for gameOVer to determine when the game is done
    bool gameOver = false;
    while(!gameOver)
    {
        // Iniializing rand
        srand(time(NULL));

        player1Turn = true;
        chipsInPile = 0;
        chipsTaken = 0;
        takechips = 0;

        std::cout << "How many chips would you like in your starting pile? \n";
        chipsInPile = read_input();
        std::cout << "This round will start with " << chipsInPile << " chips in the pile\n";

        while(chipsInPile!=0)
        {
            takechips = rand()%chipsInPile+1;
            chipsTaken += takechips;
            chipsInPile -= takechips; 
            if (player1Turn){player1Turn = false; std::cout << "Player1";}
            else{player1Turn = true; std::cout << "Player2";}

            std::cout<< " takes " << takechips << " with " << chipsTaken << " of chips taken and " << chipsInPile << " chips left in pile" << std::endl;
            
        }
        if (player1Turn){std::cout<< "Player1 LOSE!"<< std::endl;}
        else{std::cout<< "Player2 LOSE!"<< std::endl;}

        std::cout << "Play again? Y or N (or anything else)" << std::endl;
        std::cin >> decision;
        if(decision.compare("Y")!=0) {gameOver = true; std::cout << "GAME OVER" << std::endl;}
        else  continue;
    }
    return 0;
}
