//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Nikolay Kozlov on 23.09.2023.
//

@testable import ImageFeed
import XCTest

// MARK: - TESTS
final class ProfileViewTests: XCTestCase {
    let profileServiceStub = ProfileServiceStub()
    let profileImageServiceStub = ProfileImageServiceStub()
    
    func testViewControllerCalledViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadIsCalled)
    }
    
    func testPresenterSetupCalled() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter(
            profileService: profileServiceStub,
            profileImageService: profileImageServiceStub
        )
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.setupCalled)
        
    }
    
    func testPresenterUpdateAvatarCalled() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter(
            profileService: profileServiceStub,
            profileImageService: profileImageServiceStub
        )
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.updateAvatarCalled)
    }

}

