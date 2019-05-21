module Main exposing (Model, Msg(..), main, update, view, viewSidebar, viewSocialShare, viewWishListTable)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode exposing (Decoder, bool, int, list, string, succeed, decodeString, at)
import Json.Decode.Pipeline exposing (optional, required)
import Http


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = \_ -> Sub.none
    , view = view
    }


-- MODEL


type Model =
  Loading
  | Failure
  | Success (List Item)
  | Nodata


type alias Item =
  { brand: String
  , category: String
  , date: String
  , description: String
  , image: String
  , price: String
  , size: String
  , systemsize: String
  }

itemDecoder : Decoder Item
itemDecoder =
  succeed Item
    |> required "brand" string
    |> required "category" string
    |> required "date" string
    |> required "description" string
    |> required "image" string
    |> required "size" string
    |> required "systemsize" string
    |> required "price" string
    

urlPrefix : String
urlPrefix = 
  "http://localhost:4000/"

init : () -> (Model, Cmd Msg)
init _ = 
  ( Loading
  , Http.get
      { url = urlPrefix ++ "api/items"
      , expect = Http.expectJson GotItems (list itemDecoder)
      }
  )



-- UPDATE


type Msg
  = GotItems (Result Http.Error (List Item))


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotItems (Ok result) ->
      case result of
        (first :: _) as items ->
          (Success items, Cmd.none)
        [] ->
          (Nodata, Cmd.none)
    GotItems (Err _) ->
      (Failure, Cmd.none)



-- VIEW


view : Model -> Html Msg
view model =
  div 
    [ id "content" ]
    [ div [ class "l-hasSidebar" ]
      [ viewSidebar
      , viewWishList model
      ]
    ]


viewWishList : Model -> Html Msg
viewWishList model =
  div
    [ class "l-main box-bgcolor" ]
    [ div 
        [ class "title-bar pal box" ]
        [ div [ class "b-account__title lfloat" ] [ text "My Wishlist" ] ]
    , div
        [ class "b-wishlist__list pll prl" ]
        [ div [ class "l-relative clearfix b-wishlist__listItm" ]
          [ div
            [ class "b-wishlist__listHeader box mtm mbm" ]
            [ viewSocialShare
            , viewShowWishList model
            ]
          ]
        ]
    ]


viewSidebar : Html Msg
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


sidebarItems : List String
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


viewSidebarItem : List String -> Html Msg
viewSidebarItem lst =
  lst
    |> List.map
      (\item ->
        li
          [ classList [ ( "selected", item == "Wishlist" ) ] ]
          [ a 
            [ class "b-accountMenu-Itm sel-menu-myaccount"
            , href "#"
            , target "_blank"
            ]
            [ text item ]
          ]
      )
    |> ul [ class "b-accountMenu" ]


viewSocialShare : Html Msg
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
        , div [ class "clear" ] []
        ]


viewShowWishList : Model -> Html Msg
viewShowWishList model =
  case model of
    Loading ->
      div [] [ text "we are loading! ting ting ting..." ]
    Failure ->
      div [] [ text "Something went wrong..." ]
    Nodata ->
      div
        [ class "l-relative mtl mbm pbm"]
        [ text "There are no item in your wish list" ]
    Success items->
      viewWishListTable items


viewWishListTable : List Item -> Html Msg
viewWishListTable items =
    div
        [ class "wishlist-table mtl" ]
        [ table [ class "ui-borderTop ui-grid ui-gridFull" ]
            [ colgroup []
                [ col [ style "width" "15%" ] []
                , col [ style "width" "35%" ] []
                , col [ style "width" "35%" ] []
                , col [ style "width" "5%" ] []
                , col [ style "width" "10%" ] []
                ]
            , tbody
                [ class "wishlist-items" ]
                ( List.map viewWishListItem items )
            ]
        ]

viewWishListItem : Item -> Html Msg
viewWishListItem item =
  tr
    []
    [ td
        [ class "ptl pbl" ]
        [ a
            [ class "itm-wishlistImg"
            , title "Wrap Cullotes from The Executive in red_1"
            , href "#"
            ]
            [ img
                [ src item.image
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
        [ p [] [ a [ href "#", class "strong" ] [ text item.brand ] ]
        , p [] [ a [ class "itm-oos itm-time", href "#" ] [ text item.description ] ]
        , div
            [ class "price-box" ]
            [ div [ class "price-box__regular-price" ] [ span [] [ text item.price ] ] ]
        , div [ class "itm-time" ] [ text item.date ]
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
            [ i
                [ class "wl-scale40 icon_close-medium-dark" ]
                [ text "X" ]
            ]
        ]
    ]
