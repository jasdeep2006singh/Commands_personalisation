require 'cairo'

function conky_draw_clock()
    if conky_window == nil then return end
    
    -- Canvas setup
    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    local cr = cairo_create(cs)
    
    local xc = conky_window.width / 2
    local yc = conky_window.height / 2
    local radius = 80
    
    -- Grab system time tracking metrics
    local hours = tonumber(os.date("%I"))
    local mins  = tonumber(os.date("%M"))
    local secs  = tonumber(os.date("%S"))
    
    -- Convert time metrics to angle math arcs
    local alpha_sec = (secs * 6) * math.pi / 180
    local alpha_min = (mins * 6 + secs * 0.1) * math.pi / 180
    local alpha_hr  = (hours * 30 + mins * 0.5) * math.pi / 180
    
    -- ---------------------------------------------------------
    -- BATTERY PROGRESS RING & TEXT GENERATION
    -- ---------------------------------------------------------
    -- Read percentage from Conky system parser
    local bat_str = conky_parse('${battery_percent}')
    local bat_pct = tonumber(bat_str) or 0
    
    -- Draw an outermost subtle background track for the battery
    cairo_set_source_rgba(cr, 1, 1, 1, 0.05)
    cairo_set_line_width(cr, 4)
    cairo_arc(cr, xc, yc, radius + 15, 0, 2 * math.pi)
    cairo_stroke(cr)
    
    -- Set battery ring color based on capacity (Green -> Orange -> Red)
    if bat_pct > 50 then
        cairo_set_source_rgba(cr, 0.2, 0.8, 0.2, 0.7) -- Light Green
    elseif bat_pct > 20 then
        cairo_set_source_rgba(cr, 0.9, 0.5, 0.1, 0.7) -- Orange
    else
        cairo_set_source_rgba(cr, 0.9, 0.2, 0.2, 0.8) -- Warning Red
    end
    
    -- Draw active battery level progress ring (Starts from top center)
    local bat_start_angle = -math.pi / 2
    local bat_end_angle = bat_start_angle + (2 * math.pi * (bat_pct / 100))
    cairo_set_line_width(cr, 4)
    cairo_arc(cr, xc, yc, radius + 15, bat_start_angle, bat_end_angle)
    cairo_stroke(cr)
    
    -- Draw Numerical Text String underneath the clock center core
    -- cairo_select_font_face(cr, "Sans", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD)
    --cairo_set_font_size(cr, 14)
    --local text_display = bat_pct .. "%"
    
    -- Position math to cleanly center align font string text
    --local extents = cairo_text_extents_t:create()
    --cairo_text_extents(cr, text_display, extents)
    --cairo_move_to(cr, xc - (extents.width / 2), yc + (radius * 0.4))
    --cairo_show_text(cr, text_display)
    -- ---------------------------------------------------------
    
    -- Draw Clock Outer Ring Rim
    cairo_set_source_rgba(cr, 1, 1, 1, 0.2) 
    cairo_set_line_width(cr, 6)
    cairo_arc(cr, xc, yc, radius, 0, 2 * math.pi)
    cairo_stroke(cr)
    
    -- Hour Hand
    cairo_set_source_rgba(cr, 1, 1, 1, 0.9)
    cairo_set_line_width(cr, 5)
    cairo_move_to(cr, xc, yc)
    cairo_line_to(cr, xc + (radius * 0.5) * math.sin(alpha_hr), yc - (radius * 0.5) * math.cos(alpha_hr))
    cairo_stroke(cr)
    
    -- Minute Hand
    cairo_set_source_rgba(cr, 0.9, 0.9, 0.9, 0.9)
    cairo_set_line_width(cr, 3)
    cairo_move_to(cr, xc, yc)
    cairo_line_to(cr, xc + (radius * 0.75) * math.sin(alpha_min), yc - (radius * 0.75) * math.cos(alpha_min))
    cairo_stroke(cr)
    
    -- Seconds Hand
    cairo_set_source_rgba(cr, 1, 0.3, 0.3, 1) 
    cairo_set_line_width(cr, 1.5)
    cairo_move_to(cr, xc, yc)
    cairo_line_to(cr, xc + (radius * 0.85) * math.sin(alpha_sec), yc - (radius * 0.85) * math.cos(alpha_sec))
    cairo_stroke(cr)
    
    -- Clean up memory space
    cairo_destroy(cr)
    cairo_surface_destroy(cs)
end
