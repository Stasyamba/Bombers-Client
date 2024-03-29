/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.data {
public class Consts {
    public static const MAP_WIDTH_REGULAR:uint = 17;
    public static const MAP_HEIGHT_REGULAR:uint = 11;

    public static const BLOCK_SIZE:uint = 40;
    public static const BLOCK_SIZE_2:uint = BLOCK_SIZE / 2;

    //creature is within the block if it's def is:  BLOCK_START <= def < BLOCK_END
    public static const BLOCK_START:int = -BLOCK_SIZE_2;
    public static const BLOCK_END:int = BLOCK_SIZE_2;

    public static const BOMBER_SIZE:Number = 40;
    public static const BOMBER_SIZE_2:Number = BOMBER_SIZE / 2;

    public static const HEALTH_BAR_WIDTH:uint = 30;
    public static const HEALTH_BAR_HEIGHT:uint = 5;

    public static const MOVE_TIMER_DELAY:uint = 40;
    public static const GAME_REGULAR:uint = 1;
    public static const GAME_PERFOMANCE_TEST:uint = 2;
    public static const BLINKING_TIME:Number = 0.05;
    public static const EXPLOSION_DEFLATION:int = 7;
    public static const POINTER_TIME:Number = 0.5;

    public static const SMOKE_WIDTH:Number = 95
    public static const SMOKE_HEIGHT:Number = 93

    public static const LOCATIONS_COUNT:int = 9


    public static const SPEED_BONUS_MULTIPLIER:Number = 1.1
}
}