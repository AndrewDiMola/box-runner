game = {}
colors = {}
player = {}
enemy = {}

function love.load()
    game.SCREEN_WIDTH, game.SCREEN_HEIGHT = love.graphics.getDimensions()
    game.FONT = love.graphics.newFont(24)
    game.WINDOW_TITLE = "Hello Platforming World!"
    game.TITLE = "BOX RUNNER: NOW WITH FASTER BOXES"
    game.RETRY = "GAME OVER: Press Space to play again"
    game.VELOCITY_COUNTER_LOCAL_MAX = 3  -- Speed up velocity every ~3 seconds
    game.velocity_counter = 0
    game.SCOREBOARD = "SCORE:  "
    game.score = 0
    game.is_active = true

    colors.DEFAULT = {255, 255, 255}
    colors.TEXT = {0, 0, 0}
    colors.BACKGROUND = {66 / 255, 133 / 255, 244 / 255}
    colors.GROUND = {15 / 255, 157 / 255, 88 / 255}
    colors.SHAPE_OUTLINE = {0, 0, 0}
    colors.PLAYER = {244 / 255, 160 / 255, 0 / 255}
    colors.ENEMY = {219 / 255, 68 / 255, 55 / 255}

    player.x = game.SCREEN_WIDTH - (game.SCREEN_WIDTH / 1.25)
    player.y = (game.SCREEN_HEIGHT / 1.25) + 1
    player.START_Y = player.y
    player.WIDTH = 50
    player.HEIGHT = 50
    player.JUMP_HEIGHT = player.y - (2 * player.HEIGHT)
    player.GRAVITY = player.JUMP_HEIGHT / 2
    player.is_jump = false

    enemy.WIDTH = player.WIDTH / 2
    enemy.HEIGHT = player.HEIGHT / 2
    enemy.x = game.SCREEN_WIDTH + enemy.WIDTH
    enemy.y = (game.SCREEN_HEIGHT / 1.25) + 1
    enemy.START_X = enemy.x
    enemy.START_SPEED = 5
    enemy.speed = enemy.START_SPEED
    enemy.is_collide = false

    love.window.setTitle(game.WINDOW_TITLE)
    love.graphics.setFont(game.FONT)
end

function love.draw()
    love.graphics.setColor(colors.DEFAULT)
    love.graphics.setBackgroundColor(colors.BACKGROUND)

    DrawGameText()
    DrawGround(0, game.SCREEN_HEIGHT / 1.25, game.SCREEN_WIDTH, game.SCREEN_HEIGHT)
    DrawPlayer(player.x, player.y - player.HEIGHT, player.WIDTH, player.HEIGHT)
    DrawEnemy(enemy.x, enemy.y - enemy.HEIGHT, enemy.WIDTH, enemy.HEIGHT)
end

function love.keypressed(key)
    if game.is_active then
        if key == "space" and not player.is_jump then
            player.y = player.JUMP_HEIGHT
            player.is_jump = true
        end
    elseif key == "space" then
        Reset()
    end
end

function love.update(dt)
    if game.is_active then
      game.velocity_counter = game.velocity_counter + dt
        if
            (player.x + player.WIDTH > enemy.x) and (player.x < enemy.x + enemy.WIDTH) and
                (player.y > (enemy.y - enemy.HEIGHT))
         then
            enemy.is_collide = true
            game.is_active = false
        else
            game.score = game.score + 1
        end

        if player.y < player.START_Y then
            player.y = player.y + (player.GRAVITY * dt)
        else
            player.is_jump = false
        end

        if enemy.x > 0 - enemy.WIDTH and not enemy.is_collide then
            enemy.x = enemy.x - enemy.speed
        elseif not enemy.is_collide then
            enemy.x = enemy.START_X
        end

        if game.velocity_counter > game.VELOCITY_COUNTER_LOCAL_MAX then
            enemy.speed = enemy.speed + 1
            game.velocity_counter = 0
        end
    end
end

function DrawGameText()
    love.graphics.setColor(colors.TEXT)
    if (game.is_active) then
        love.graphics.printf(
            game.TITLE,
            0,
            (game.SCREEN_HEIGHT / 10) - (game.FONT:getHeight() / 2),
            game.SCREEN_WIDTH,
            "center"
        )
    else
        love.graphics.printf(
            game.RETRY,
            0,
            (game.SCREEN_HEIGHT / 10) - (game.FONT:getHeight() / 2),
            game.SCREEN_WIDTH,
            "center"
        )
    end
    love.graphics.printf(
        game.SCOREBOARD,
        0 - (game.FONT:getWidth(game.SCOREBOARD) / 2),
        (game.SCREEN_HEIGHT / 5) - (game.FONT:getHeight() / 2),
        game.SCREEN_WIDTH,
        "center"
    )
    love.graphics.printf(
        game.score,
        (0 - (game.FONT:getWidth(game.SCOREBOARD) / 2)) +
            ((game.FONT:getWidth(game.SCOREBOARD) / 2) + (game.FONT:getWidth(game.score) / 2)),
        (game.SCREEN_HEIGHT / 5) - (game.FONT:getHeight() / 2),
        game.SCREEN_WIDTH,
        "center"
    )
end

function DrawGround(x, y, width, height)
    love.graphics.setColor(colors.GROUND)
    love.graphics.rectangle("fill", x, y, width, height)

    love.graphics.setColor(colors.SHAPE_OUTLINE)
    love.graphics.rectangle("line", x, y, width, height)
end

function DrawPlayer(x, y, width, height)
    love.graphics.setColor(colors.PLAYER)
    love.graphics.rectangle("fill", x, y, width, height)
    love.graphics.setColor(colors.SHAPE_OUTLINE)
    love.graphics.rectangle("line", x, y, width, height)
end

function DrawEnemy(x, y, width, height)
    love.graphics.setColor(colors.ENEMY)
    love.graphics.rectangle("fill", x, y, width, height)
    love.graphics.setColor(colors.SHAPE_OUTLINE)
    love.graphics.rectangle("line", x, y, width, height)
end

function Reset()
    game.score = 0
    player.y = player.START_Y
    enemy.x = enemy.START_X
    enemy.is_collide = false
    enemy.speed = enemy.START_SPEED
    game.is_active = true
end
