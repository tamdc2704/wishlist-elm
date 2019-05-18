module Main exposing (Model, Msg(..), default, main, update, view, viewSidebar, viewSocialShare, viewWishListTable)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main =
    Browser.sandbox { init = default, update = update, view = view }



-- MODEL

type alias Model =
    { books : Int }


default =
    { books = 0 }



-- UPDATE


type Msg
    = Increament
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increament ->
            { model | books = model.books + 1 }

        Decrement ->
            { model | books = model.books - 1 }



-- VIEW

view : Model -> Html Msg
view model =
    div [ id "content" ] 
        [ div [class "l-hasSidebar" ] 
            [ viewSidebar
            , viewWishList model
            ] 
        ]


viewWishList : Model -> Html Msg
viewWishList model =
    div 
        [ class "l-main box-bgcolor" ]
        [ div [ class "title-bar pal box" ]
            [ div [ class "b-account__title lfloat" ] [ text "My Wishlist" ] ]
        , div 
            [ class "b-wishlist__list pll prl" ]
            [ div [ class "l-relative clearfix b-wishlist__listItm" ]
                [ div 
                    [ class "b-wishlist__listHeader box mtm mbm" ]
                    [ viewSocialShare
                    , viewWishListTable
                    ]
                ]
            ]
        ]


viewSidebar =
    div
        [ class "l-sidebar box-bgcolor" ]
        [ div 
            [ class "customer_menu" ] 
            [ div 
                []
                [ h5 [ class "accMenuPad" ] [ text "My Account" ]
                , viewSidebarItem sidebarItems
                ]
            ] 
        ]

sidebarItems = 
    [ "Account Information"
    , "My Wallet"
    , "My Memberships"
    , "Orders & Tracking"
    , "Exchange & Return"
    , "Preferences"
    , "Wishlist"
    , "Rewards"
    ]

viewSidebarItem: List String -> Html Msg
viewSidebarItem lst =
    lst
        |> List.map 
            (\item -> 
                li 
                    [ classList [("selected", item == "Wishlist")]] 
                    [ a [ class "b-accountMenu-Itm sel-menu-myaccount", href "#", target "_blank" ][ text item ] ] 
            )
        |> ul [ class "b-accountMenu" ]


viewSocialShare =
    div 
        [ class "mbl" ]
        [ div [ class "lfloat size1of2" ]
            [ div [ class "wishlistShare mrm mts social-buttons ui-inlineBlock" ]
                [ h6 [ class "social-buttons_label" ] [ text "Share" ]
                , span [ class "mll" ]
                    [ a
                        [ class "social-buttons_button share"
                        , name "Facebook"
                        , target "_blank"
                        , rel "noopener"
                        , href "#"
                        ]
                        [ i [ class "icon-facebook" ] [] ]
                    ]
                , span [ class "mll" ]
                    [ a
                        [ class "social-buttons_button share"
                        , name "Twitter"
                        , target "_blank"
                        , rel "noopener"
                        , href "#"
                        ]
                        [ i [ class "icon-twitter" ] [] ]
                    ]
                , span [ class "mll" ]
                    [ a
                        [ class "social-buttons_button share"
                        , name "Google +"
                        , target "_blank"
                        , rel "noopener"
                        , href "#"
                        ]
                        [ i [ class "icon-google-plus" ] [] ]
                    ]
                ]
            ]
        , div [class "clear"] []
        ]


viewWishListTable =
    div 
        [ class "wishlist-table mtl" ]
        [ table [ class "ui-borderTop ui-grid ui-gridFull" ]
            [ colgroup []
                [ col [ style "width" "15%" ] []
                , col [ style "width" "15%" ] []
                , col [ style "width" "15%" ] []
                , col [ style "width" "15%" ] []
                ]
            , tbody
                [ class "wishlist-items" ]
                [ tr
                    []
                    [ td
                        [ class "ptl pbl" ]
                        [ a
                            [ class "itm-wishlistImg"
                            , title "Wrap Cullotes from The Executive in red_1"
                            , href "#"
                            ]
                            [ img
                                [ src "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS60AkJ5uIuXe9mmJCo_L4O-gW47OU-u3NU4eVc1AB2VQS3ERfn"
                                , title "Wrap Cullotes from The Executive in red_1"
                                , alt "Wrap Cullotes from The Executive in red_1"
                                , width 75
                                , height 108
                                ]
                                []
                            ]
                        ]
                    , td
                        [ class "ptl pbl" ]
                        [ p [] [ a [ href "#", class "strong" ] [ text "The Executive" ] ]
                        , p [] [ a [ class "itm-oos itm-time", href "#" ] [ text "Wrap Cullotes" ] ]
                        , div
                            [ class "price-box" ]
                            [ div [ class "price-box__regular-price" ] [ span [] [ text "RM 99.00" ] ] ]
                        , div [ class "itm-time" ] [ text "Added on: 2019-05-17" ]
                        ]
                    , td
                        [ class "ptl pbl" ]
                        [ div
                            [ class "prdSizeOption box size pbl" ]
                            [ select
                                [ class "js-wlSizeSystem" ]
                                [ option [ value "International" ] [ text "International" ]
                                , option [ value "Waist Size" ] [ text "Waist Size" ]
                                ]
                            , div [ class "pbs" ] []
                            , select
                                [ class "js-wlSize" ]
                                [ option [ disabled True ] [ text "Choose size" ]
                                , option [ value "S" ] [ text "S" ]
                                , option [ value "M" ] [ text "M" ]
                                , option [ value "L", selected True ] [ text "L" ]
                                , option [ value "XL" ] [ text "XL" ]
                                ]
                            ]
                        ]
                    , td [ class "emptyColumn" ] []
                    , td
                        [ class "addToCart ptl pbl" ]
                        [ a [ class "btn btn--fluid", title "Add to Bag" ] [ text "Add to Bag" ]
                        , div [ class "icon i-loader", style "display" "none" ] []
                        , div
                            [ class "mtl wishListMenuWrapper b-wishlist__listOption" ]
                            [ a
                                [ class "toggleWishListMenu close open"
                                , title "Share"
                                , href "#"
                                , style "display" "inline"
                                ]
                                [ text "Share" ]
                            , div
                                [ class "wishlistShare wishListMenu wishShare-popover wishlist-share-product display-none"
                                , style "display" "none"
                                ]
                                [ div
                                    [ class "wishlist-share-padding wishlist-share-noborder" ]
                                    [ h3 [ class "wishlist-share-list lfloat" ] [ text "Share on" ]
                                    , a
                                        [ class "wishlist-share-close rfloat"
                                        , href "javascript:void(0)"
                                        ]
                                        [ i [ class "wl-scale40 icon_close-medium-dark" ] [] ]
                                    , div [ class "clear" ] []
                                    ]
                                , div
                                    [ class "wishlist-share-padding" ]
                                    [ div
                                        [ style "padding-left" "14px" ]
                                        [ a
                                            [ class "i-facebook lfloat share"
                                            , name "Facebook"
                                            , target "_blank"
                                            , rel "noopener"
                                            , href "#"
                                            ]
                                            []
                                        , a
                                            [ class "i-twitter lfloat share"
                                            , name "Twitter"
                                            , target "_blank"
                                            , rel "noopener"
                                            , href "#"
                                            ]
                                            []
                                        , a
                                            [ class "i-googleplus lfloat share"
                                            , name "Google +"
                                            , target "_blank"
                                            , rel "noopener"
                                            , href "#"
                                            ]
                                            []
                                        , div [ class "clear" ] []
                                        ]
                                    ]
                                ]
                            ]
                        , div
                            [ class "paml box wl-item__delete-popover display-none"
                            , style "display" "none"
                            ]
                            [ div [ class "itm__delete-title clear pbl" ] [ text "Remove item?" ]
                            , button
                                [ class "btn btn--fluid mbs"
                                , type_ "button"
                                , title "No"
                                ]
                                [ text "No" ]
                            , button
                                [ class " btn btn--secondary btn--fluid"
                                , type_ "button"
                                , title "Yes"
                                ]
                                [ text "Yes" ]
                            ]
                        , div
                            [ class "removeWishlistItem" ]
                            [ i [ class "wl-scale40 icon_close-medium-dark" ] [ text "X" ] ]
                        ]
                    ]
                ]
            ]
        ]
